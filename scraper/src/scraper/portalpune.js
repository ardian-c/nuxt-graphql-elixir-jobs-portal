const Apify = require("apify");
const moment = require("moment");
var colors = require("colors/safe");
// const db = require('../../db');
const { Pool } = require("pg");

const pool = new Pool();
const commonUtils = require("../../utils");

// Apify.utils contains various utilities, e.g. for logging.
// Here we turn off the logging of unimportant messages.
const { log } = Apify.utils;
log.setLevel(log.LEVELS.WARNING);

// A link to a list of Fortune 500 companies' websites available on GitHub.
const CSV_LINK =
  "https://gist.githubusercontent.com/ardian-c/d82fa6d449c37be406317a643633b297/raw/fbf1b24641b25f041728431a81ece76d1c11e15b/test3.csv";

// Apify.main() function wraps the crawler logic (it is optional).
Apify.main(async () => {
  // Create an instance of the RequestList class that contains a list of URLs to crawl.
  // Here we download and parse the list of URLs from an external file.
  const requestList = new Apify.RequestList({
    sources: [{ requestsFromUrl: CSV_LINK }]
  });
  await requestList.initialize();

  // Create an instance of the CheerioCrawler class - a crawler
  // that automatically loads the URLs and parses their HTML using the cheerio library.
  const crawler = new Apify.CheerioCrawler({
    // Let the crawler fetch URLs from our list.
    requestList,

    // The crawler downloads and processes the web pages in parallel, with a concurrency
    // automatically managed based on the available system memory and CPU (see AutoscaledPool class).
    // Here we define some hard limits for the concurrency.
    minConcurrency: 10,
    maxConcurrency: 50,

    // On error, retry each page at most once.
    maxRequestRetries: 1,

    // Increase the timeout for processing of each page.
    handlePageTimeoutSecs: 60,

    // This function will be called for each URL to crawl.
    // It accepts a single parameter, which is an object with the following fields:
    // - request: an instance of the Request class with information such as URL and HTTP method
    // - html: contains raw HTML of the page
    // - $: the cheerio object containing parsed HTML
    handlePageFunction: async ({ request, html, $ }) => {
      $.prototype.exists = function (selector) {
        return this.find(selector).length > 0;
      }
      
      const hasPdfLink = $(html).exists("div.pDescription > img[src*='/images/kliko.png']");

      // Extract data from the page using cheerio.
      const title = $("h2.vacancyTitle").text();
      const category = $("#personAndDates > dl:nth-child(3) > p").text();
      const company = $("#vacancySummary > #defLists > dl:nth-child(1) > p").text();
      let content = '';
      
      if (hasPdfLink) {
        content = `<p>Kliko në <a href="https://www.portalpune.com/${$(".pDescription > p")
          .find("a")
          .attr("href")}">linkun </a>për të vizituar shpalljen</p>`;
      } else {
        content = $("div.pDescription").html();
      }

      const location = $("#personAndDates > dl:nth-child(4) > p").text();
      const deadline = $("#personAndDates > dl:nth-child(2) > p").text();

      console.log(`Processing ${request.url}...${title}`);

      // Store the results to the default dataset. In local configuration,
      // the data will be stored as JSON files in ./apify_storage/datasets/default
      await Apify.pushData({
        url: request.url,
        title,
        content,
        category,
        company,
        location,
        deadline
      });

      /**
       * 1. Check if job application exists.
       * 2. Check if company exists, 
       * 3. If yes - get the id else insert and get the id 
       * 4.Check if category exists
       * 5. If yes - get the id, else insert and get the id
       * 6. Insert job application
       * 7. Insert job application category relation (pivot)
       */

      (async () => {
        const client = await pool.connect();

        try {
          await client.query("BEGIN");
          const lastInsertQuery = "SELECT id FROM job_applications WHERE source=$1";

          const slug = commonUtils.sluggify(title);
          // save results 
          const parsedDeadline = moment(deadline.split(".").reverse().join("-")).format('YYYY-MM-DD HH:mm:ss');
          const insertedAt = moment().format('YYYY-MM-DD HH:mm:ss');
          const updatedAt = moment().format("YYYY-MM-DD HH:mm:ss");

          let categoryId = 1;

          const jobApplicationExists = await client.query(lastInsertQuery, [request.url]);

          if (jobApplicationExists.rows.rowCount == 1) {
            // url already exists
            return;
          } else {
            if (category !== '' && category.length <= 50) {
              const categoryExistsQuery = "SELECT id FROM categories WHERE name=$1";

              const categoryExists = await client.query(categoryExistsQuery, [category.toLowerCase()]);

              if (categoryExists.rowCount == 1) {
                categoryId = categoryExists.rows[0].id;
              } else {
                const insertCategoryQuery = "INSERT INTO categories(name, description, inserted_at, updated_at) VALUES($1, $2, $3, $4) RETURNING *;";
                const insertedCategory = await client.query(
                  insertCategoryQuery,
                  [category.toLowerCase(), "", insertedAt, updatedAt]
                );

                categoryId = insertedCategory.rows[0].id;
              }
            }

            // check if company exists, if not create one
            const companyExistsQuery = 'SELECT * FROM companies WHERE name=$1';
            let companyId = 1;

            const companyExists = await client.query(companyExistsQuery, [company]);

            console.log(colors.green('existing company: ', companyExists.rows[0]));

            if (typeof companyExists.rows[0] === 'undefined') {
              if (company.length <= 50) {
                // check if company exists, if not create
                console.log(colors.white("company inserted ", company));
                const insertCompaniesQuery = "INSERT INTO companies(name, address, inserted_at, updated_at) VALUES ($1, $2, $3, $4) RETURNING *;";

                const insertedCompany = await client.query(
                  insertCompaniesQuery,
                  [company, location, insertedAt, updatedAt]
                );
                companyId = insertedCompany.rows[0].id;
              }
            } else {
              companyId = companyExists.rows[0].id;
            }

            const insertJobApplicationQuery = "INSERT INTO job_applications(title,content,slug,address,status,priority,source,ends_at, inserted_at, updated_at, company_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING *;";
            const jobApplicationValues = [title, content, slug, location, 3, 1, request.url, parsedDeadline, insertedAt, updatedAt, companyId];

            const insertedJobApplication = await client.query(insertJobApplicationQuery, jobApplicationValues);

            const jobApplicationId = insertedJobApplication.rows[0].id;

            const addRelationQuery = "INSERT INTO job_application_categories (job_application_id,category_id) VALUES ($1, $2) RETURNING *;";
            const addRelationValues = [jobApplicationId, categoryId];

            await client.query(addRelationQuery, addRelationValues);
            console.log(colors.yellow("saved to db 🔥👌"));

            await client.query("commit");
          }
        } catch (e) {
          await client.query("ROLLBACK");
          console.log(colors.red(e.stack));
        } finally {
          client.release();
        }
      })().catch(e => console.error(colors.red(e.stack)));
    },

    // This function is called if the page processing failed more than maxRequestRetries+1 times.
    handleFailedRequestFunction: async ({ request }) => {
      console.log(`Request ${request.url} failed twice.`);
    }
  });

  // Run the crawler and wait for it to finish.
  await crawler.run();

  console.log("Crawler finished.");
});
