
const Apify = require('apify');
const requestPromise = require('request-promise');

const cheerio = require("cheerio");
const createCsvWriter = require("csv-writer").createObjectCsvWriter;

// Apify.main() function wraps the crawler logic (it is optional).
Apify.main(async () => {
    // Create and initialize an instance of the RequestList class that contains
    // a list of URLs to crawl. Here we use just a few hard-coded URLs.
    const requestList = new Apify.RequestList({
        sources: [
            { url: 'https://puna.telegrafi.com/' },
            { url: 'https://puna.telegrafi.com/?faqe=2'},
            { url: 'https://puna.telegrafi.com/?faqe=3'},
            { url: 'https://puna.telegrafi.com/?faqe=4'},
            { url: 'https://puna.telegrafi.com/?faqe=5'},
            { url: 'https://www.portalpune.com/' },
            { url: 'https://www.kosovajob.com/' },  
        ],
    });

    await requestList.initialize();

    // Create a BasicCrawler - the simplest crawler that enables
    // users to implement the crawling logic themselves.
    const crawler = new Apify.BasicCrawler({

        // Let the crawler fetch URLs from our list.
        requestList,

        // This function will be called for each URL to crawl.
        // The 'request' option is an instance of the Request class, which contains
        // information such as URL and HTTP method, as supplied by the RequestList.
        handleRequestFunction: async ({ request }) => {
            console.log(`Processing ${request.url}...`);
            const html = await requestPromise(request.url);
            $ = cheerio.load(html);
            
            if (request.url === 'https://puna.telegrafi.com/' || 
                request.url === 'https://puna.telegrafi.com/?faqe=2' ||
                request.url === 'https://puna.telegrafi.com/?faqe=3' ||
                request.url === 'https://puna.telegrafi.com/?faqe=4' ||
                request.url === 'https://puna.telegrafi.com/?faqe=5') {
                const records = [];
                const csvFile = "./apify_storage/csv/telegrafi.csv";
                $(".pun_post_box").each((index, el) => {
                    let item = {
                        title: $(el).find("h2.pun_kategory_title").text(),
                        description: $(el).find("a.pun_position_title").text(),
                        url: $(el).find("a.pun_position_title").attr("href")    
                    };
                    records.push(item);
                });

                console.log(records);
                //  description: 'description', url: 'url' 
                const telegrafiWriter = createCsvWriter({
                    path: csvFile,
                    header: [
                        { id: 'title', title: 'title'},
                        { id: 'description', title: 'description'},
                        { id: 'url', title: 'url'}
                    ],
                    append: true
                });

                // reset before writing
                await telegrafiWriter
                .writeRecords([]) // returns a promise
                .then(() => {
                    console.log(`Remove all records before inserting ${csvFile}.`);
                });

                await telegrafiWriter
                .writeRecords(records) // returns a promise
                .then(() => {
                    console.log(`...Finished saving jobs to ${csvFile}.`);
                });
            }

            if (request.url === 'https://www.portalpune.com/') {
                const records = [];
                const csvFile = "./apify_storage/csv/portalpune.csv";

                $(".crsl-item").each((index, el) => {
                    return;
                    let item = {
                        title: $(el).find('.premium-info h4').first().text(), 
                        description: $(el).next('h4').text(),
                        url: `${$(el).find('.premium-info a').attr("href")}`
                    };
                    records.push(item);
                });

                $("#featuredEmployers .item").each((index, el) => {
                    let item = {
                        title: $(el).first('h4').text(),
                        description: $(el).first('h4').text(),
                        url: `${$(el).find('a').first().attr("href")}`
                    };
                    records.push(item);
                });

                console.log(records);

                const portalpuneWriter = createCsvWriter({
                    path: csvFile,
                    header: [
                        { id: 'title', title: 'title' },
                        { id: 'description', title: 'description' },
                        { id: 'url', title: 'url' }
                    ],
                    append: true
                });
                // reset before writing
                await portalpuneWriter
                    .writeRecords([]) // returns a promise
                    .then(() => {
                        console.log(`Remove all records before inserting ${csvFile}.`);
                    });

                // write   
                await portalpuneWriter
                .writeRecords(records) // returns a promise
                .then(() => {
                console.log(`...Finished saving jobs to ${csvFile}.`);
                });
            }

            if (request.url === 'https://www.kosovajob.com/') {
                let records = [];
                const csvFile = "./apify_storage/csv/kosovajob.csv";
                $(".listsMobile").each((index, el) => {
                    let item = {
                        title: $(el).find("div.listsPosition").first().text(), description: $(el).find("div.listsPosition").first().text(),
                        url: `https://www.kosovajob.com/${$(el).find('a').first().attr("href")}`
                    };
                    records.push(item);
                });

                console.log(records);

                const kosovajobWriter = createCsvWriter({
                    path: csvFile,
                    header: [
                        { id: 'title', title: 'title' },
                        { id: "description", title: "description" },
                        { id: "url", title: "url" }
                    ],
                    append: true
                });

                // reset before writing
                await kosovajobWriter
                .writeRecords([]) // returns a promise
                .then(() => {
                    console.log(`Remove all records before inserting ${csvFile}.`);
                });

                await kosovajobWriter
                .writeRecords(records) // returns a promise
                .then(() => {
                console.log(`...Finished saving jobs to ${csvFile}.`);
                });
            }

            // Store the HTML and URL to the default dataset.
            await Apify.pushData({
                url: request.url,
                html,
            });
        },
    });

    // Run the crawler and wait for it to finish.
    await crawler.run();

    console.log('Crawler finished.');
});