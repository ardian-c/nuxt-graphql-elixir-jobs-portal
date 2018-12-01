<template>
  <div class="container content-wrapper">
    <div class="job-content-header">
      <a-row>
        <a-col :span="6">
          <strong>Jobs</strong>/<strong>All Positions</strong>
        </a-col>

        <a-col
          :span="6"
          :offset="12"
          >
          <a-row type="flex" justify="end">
            <strong>Showing:&nbsp;{{ job_applications.length }}</strong>&nbsp;from&nbsp;<strong> {{ total }}</strong>&nbsp;jobs
          </a-row>
        </a-col>
      </a-row>
    </div>

    <div class="job-content">
      <div class="job-main-filters">
        <a-row>
          <a-col :span="8">
            <a-row type="flex" justify="start">
              <a-button icon="delete" @click="clearSearchFilters">Clear Search</a-button>
            </a-row>
          </a-col>

          <a-col :span="8">
            <a-row type="flex" justify="center">
              <a-button-group>
                <a-button icon="bars" />
                <a-button icon="appstore-o" />
              </a-button-group>
            </a-row>
          </a-col>

          <a-col :span="8">
            <a-row type="flex" justify="end">
              <a-dropdown>
                <a-menu slot="overlay" @click="sortMenuClick">
                  <a-menu-item key="1"><a-icon type="line-chart" />Most Relevant</a-menu-item>
                  <a-menu-item key="2"><a-icon type="calendar" />Published</a-menu-item>
                  <a-menu-item key="3"><a-icon type="team" />Employer</a-menu-item>
                  <a-menu-item key="4"><a-icon type="environment-o" />Place</a-menu-item>
                </a-menu>
                <a-button style="margin-left: 8px">
                  Sort On <a-icon type="down" />
                </a-button>
              </a-dropdown>
            </a-row>
          </a-col>
        </a-row>
      </div>

      <div class="job-main">
        <a-col :span="6">
          <div class="job-advanced-filters">
            <!--<p>Published</p>
            <div>
              <a-checkbox @change="showOnlyTodayListings">New Today (42)</a-checkbox>
              <br /><br />
            </div>
-->
            <div>
              <a-input-search
                placeholder="search for jobs"
                style="width: 200px"
                v-model="filterByKeyword"
                @search="onSearch"
              />
              <br /><br />
            </div>

            <div>
              <p>Categories</p>
              <p v-for="cat of categories" :key="cat.id">
                <a-checkbox @change="showByCategory($event, cat.id)">{{ cat.name }} ({{ cat.count_posts }})</a-checkbox>
              </p>
            </div>

            <div>
              <p>Cities</p>
              <a-radio-group @change="showByCity" v-model="filterByCity">
                <a-radio :style="radioStyle"  v-for="city of cities" :value="city.id" :key="city.id">{{ city.description }} ({{ city.count_posts}})</a-radio>
              </a-radio-group>
            </div>
          </div>
        </a-col>

        <!--<a-col :span="18">
          <div class="job-listings">
            <a-row v-for="(job, i) of jobs" :key="i" class="job">
              <div class="company_logo">
                <img :src="job.company_logo" :alt="job.company_name">
              </div>

              <div class="job-content-text">
                <h3>{{ job.title }}</h3>
                <p>{{ job.position }} <a-tag color="green" v-if="job.open_positions > 1">{{ job.open_positions }}</a-tag></p>
              </div>
            </a-row>
          </div>
        </a-col>-->

        <a-col :span="18">
          <a-list>
            <virtual-scroller
              style="height:850px"
              :items="job_applications"
              item-height="80"
              v-infinite-scroll="handleInfiniteOnLoad"
              :infinite-scroll-disabled="busy"
              :infinite-scroll-distance="10"
              itemLayout="horizontal"
            >
              <a-list-item slot-scope="{item}">
                <a-list-item-meta :description="item.title">
                  <a slot="title" :href="'jobs/' + item.slug">{{item.title}}</a>
                  <a-avatar slot="avatar" shape="square" src="https://i.imgur.com/o8R9P2o.jpg" />
                </a-list-item-meta>
                <div style="padding: 0 1em;"><a-button >View Position</a-button>
                </div>
              </a-list-item>
            </virtual-scroller>
            <a-spin v-if="loading"  class="jobs-loading" />
          </a-list>
        </a-col>
      </div>
    </div>
  </div>
</template>

<script>
import * as moment from 'moment';

import JOB_APPLICATIONS_QUERY from '~/apollo/queries/allJobApplications.gql';
import JOB_CITIES_ORDER_BY_POSTS_QUERY from '~/apollo/queries/allCitiesOrderByPosts.gql';
import JOB_CATEGORIES_ORDER_BY_POSTS_QUERY from '~/apollo/queries/allCategoriesOrderByPosts.gql';

export default {

  apollo: {
    allJobApplications: {
      prefetch: true,
      query: JOB_APPLICATIONS_QUERY,
      variables: {
        offset: 0,
        keyword: '',
        time: '',
        jcat: null,
        jcity: null,
      },
      result({ data }) {
        console.log('prefetched jobs: ', data);
        this.job_applications = data.allJobApplications;
        this.total = data.countJobApplications;
      }
    },

    allCategoriesOrderByPosts: {
      prefetch: true,
      query: JOB_CATEGORIES_ORDER_BY_POSTS_QUERY,
      variables: {},
      result({ data }) {
        console.log('prefetched categories: ', data);
        this.categories = data.allCategoriesOrderByPosts;
      }
    },

    allCitiesOrderByPosts: {
      prefetch: true,
      query: JOB_CITIES_ORDER_BY_POSTS_QUERY,
      variables: {},
      result({ data }) {
        console.log('prefetched city: ', data);
        this.cities = data.allCitiesOrderByPosts;
      }
    }
  },

  directives: {
  },

  components: {

  },

  data() {
    return {
      busy: false,
      total: 0,
      current: ['home'],
      radioStyle: {
        display: 'block',
        height: '30px',
        lineHeight: '30px',
      },
      filterByCity: '',
      filterByKeyword: '',
      filters: {
        offset: 0,
        keyword: '',
        time: '',
        category: null,
        city: null
      },
      categories: [],
      cities: [],
      job_applications: [],
      perPage: 25,
      offset: 0,
      pagination: {},
      loading: false,
      selectedRowKeys: [],
      searchText: '',
      columns: [{
        title: 'Title',
        dataIndex: 'title',
        key: 'title',
        scopedSlots: {
          filterDropdown: 'filterDropdown',
          filterIcon: 'filterIcon',
          customRender: 'customRender',
        },
        onFilter: (value, record) => record.name.toLowerCase().includes(value.toLowerCase()),
        onFilterDropdownVisibleChange: (visible) => {
          if (visible) {
            setTimeout(() => {
              this.$refs.searchInput.focus()
            })
          }
        },
      }, {
        title: 'Action',
        key: 'action',
        scopedSlots: { customRender: 'action' },
      }],
    }
  },

  beforeMount () {
    // this.getData((res) => {
    //   this.data = res.results.map((item, index) => ({ ...item, index }))
    // })
  },

  mounted () {
    // this.getCategoriesOrderByPosts();
  },

  methods: {
    moment,

    async handleInfiniteOnLoad() {
      const tempData = this.job_applications;
      this.loading = true;

      const keyword = this.filters.keyword;
      let offset = this.job_applications.length;

      const time = this.filters.time;
      const city = parseInt(this.filters.city);
      const category = parseInt(this.filters.category);

      const apolloClient = this.$apollo.provider.defaultClient;

      console.log(':::::::::::::: offset: ', offset);

      await apolloClient.query({
        query: JOB_APPLICATIONS_QUERY,
        variables: {
          offset,
          keyword,
          time,
          jcat: category,
          jcity: city,
        }
      }).then(({data}) => {
        this.loading = false;
        if (data.allJobApplications.length > this.perPage) {
          this.$message.warning('No more jobs to show!');
          this.busy = true;
          this.loading = false;
          return
        }

        this.job_applications = this.job_applications.concat(data.allJobApplications);
        return data;
      }).catch((err) => {
        this.loading = false;
        console.log("err: ", err);
      });
    },

    async getFilteredData() {
      const keyword = this.filters.keyword;
      let offset = 0;

      // const offset = (this.job_applications.length > 0 ) ? this.job_applications.length + this.perPage : 0;
      const time = this.filters.time;
      const city = parseInt(this.filters.city);
      const category = parseInt(this.filters.category);

      const apolloClient = this.$apollo.provider.defaultClient;

      this.loading = true;

      await apolloClient.query({
        query: JOB_APPLICATIONS_QUERY,
        variables: {
          offset,
          keyword,
          time,
          jcat: category,
          jcity: city,
        }
      }).then(({data}) => {
        this.loading = false;
        if (data.allJobApplications.length > this.perPage) {
          this.$message.warning('No more jobs to show!');
          this.busy = true;
          this.loading = false;
          return
        }

        this.job_applications = data.allJobApplications;
        return data;
      }).catch((err) => {
        this.loading = false;
        console.log("err: ", err);
      });
    },

    sortMenuClick() {
      console.log('sort menu clicked');
    },

    showOnlyTodayListings(e) {
      const now = moment();
      const jobs = [];

      if(e.target.checked) {
        this.filters.time = now;
      } else {
        this.filters.time = '';
      }

      this.getFilteredData();
    },

    async showByCategory(e, cat) {
      if(e.target.checked) {
        this.filters.category = parseInt(cat);
      } else {
        this.filters.category = '';
      }
      console.log(this.filters.category);
      await this.getFilteredData();
    },

    async showByCity(e) {
      this.filters.city = parseInt(this.filterByCity);
      console.log(this.filters.city);
      await this.getFilteredData();
    },

    async onSearch(e) {
      if(this.filterByKeyword.length >= 2){
        this.filters.keyword = this.filterByKeyword;
      } else {
        this.filters.keyword = '';
      }
      console.log('searched for: ', e);
      await this.getFilteredData();
    },

    onSelectChange (selectedRowKeys) {
      console.log('selectedRowKeys changed: ', selectedRowKeys);
      this.selectedRowKeys = selectedRowKeys
    },

    async clearSearchFilters() {
      console.log('...clearing filters');
      this.filters.city = null;
      this.filters.category = null;
      this.filters.keyword = '';
      this.filters.time = '';
      this.filterByKeyword = '';
      this.filterByCity = '';

      await this.getFilteredData();
      console.log(this.filters);
    }
  }
}
</script>

<style scoped>
.job-content-header {
  margin-top: 2em;
}

.job-main-filters {
  margin-top: 1em;
}

.job-main {
  margin-top: 2em;
}

.job {
  clear: both;
  min-height: 150px;
  border: 1px dotted #444444;
}

.job .company_logo {
  width: 25%;
  float: left;
}

.job .company_logo img {
  max-width: 100%;
  width: 100%;
}

.job .job-content-text {
  width: 60%;
  margin-left: 10%;
  float: left;
}

.jobs-loading {
  position: absolute;
  bottom: 40px;
  width: 100%;
  text-align: center;
}
</style>

