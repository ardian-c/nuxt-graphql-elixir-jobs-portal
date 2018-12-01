<template>
  <div class="single-job-container">
    single job - {{ route.params.id }}
  </div>
</template>

<script>
  import * as moment from 'moment';

  import SINGLE_JOB_APPLICATION_QUERY from '~/apollo/queries/singleJobApplicationBySlug.gql';

  export default {
    head() {
      return {
        title: 'Npune | ' + this.job_application.title,
        meta: [
          { hid: 'job application', name: 'job application', content: this.job_application.title}
        ]
      }
    },

    apollo: {
      singleJobApplication: {
        query: SINGLE_JOB_APPLICATION_QUERY,
        prefetch: ({ route }) => ({ id: route.params.id }),
        variables() {
          return { slug: this.$route.params.id }
        },
        result({ data }) {
          console.log('::: DATA ::: ', data);
          this.job_application = data.singleJobApplication;
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

</style>
