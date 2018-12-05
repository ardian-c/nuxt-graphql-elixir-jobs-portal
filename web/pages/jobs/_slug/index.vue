<template>
  <div class="container content-wrapper">
    <div class="single-job-container">
      <a-row :gutter="16">
        <a-col :span="18">
          <a-card title="Job Description" :bordered=false>
            <h1>{{ job_application.title }}</h1>
            <div v-html="job_application.content"> </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card title="Information" :bordered=false>
            <p><strong>Company: </strong>{{ job_application.company.name }}</p>
            <p><strong>Category: </strong>{{ job_application.categories[0]["name"] }}</p>
          </a-card>
        </a-col>
      </a-row>
    </div>
  </div>
</template>

<script>
  import * as moment from 'moment';

  import SINGLE_JOB_APPLICATION_BY_SLUG_QUERY from '~/apollo/queries/singleJobApplicationBySlug.gql';

  export default {
    head() {
      return {
        title: 'Npunë | ' + this.job_application.title,
        meta: [
          { hid: 'job application', name: 'job application', content: ''}
        ]
      }
    },

    apollo: {
      singleJobApplicationBySlug: {
        query: SINGLE_JOB_APPLICATION_BY_SLUG_QUERY,
        prefetch: ({ route }) => ({ slug: route.params.slug }),
        variables() {
          return { slug: this.$route.params.slug }
        },
        result({ data }) {
          console.log('::: DATA ::: ', data);
          this.job_application = data.singleJobApplicationBySlug;
          this.job_application.company_id = this.job_application.company.id;
        }
      }
    },

    mounted() {

    },

    data() {
      return {
        job_application: {
          title: '',
          content: '',
          slug: '',
          address: '',
          status: 'publish',
          priority: 'lowest priority (1)',
          source: '',
          ends_at: '',
          published_at: '',
          company_id: '',
          categories: [],
          is_scheduled: false
        },
      }
    },

    methods: {
      moment,
    }
  }
</script>

<style>
.single-job-container {
  padding: 30px 0;
}
</style>
