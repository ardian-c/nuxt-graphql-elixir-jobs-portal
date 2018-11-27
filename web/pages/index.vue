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
            <strong>19 698</strong> positions in <strong>{{ total }}</strong> ads
          </a-row>
        </a-col>
      </a-row>
    </div>

    <div class="job-content">
      <div class="job-main-filters">
        <a-row>
          <a-col :span="8">
            <a-row type="flex" justify="start">
              <a-button icon="star-o">Save Search</a-button>
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
            <p>Published</p>
            <div>
              <a-checkbox @change="showOnlyTodayListings">New Today (42)</a-checkbox>
              <br /><br />
            </div>

            <div>
              <a-input-search
                placeholder="search for jobs"
                style="width: 200px"
                @search="onSearch"
              />
              <br /><br />
            </div>

            <div>
              <p>Categories</p>
              <p v-for="cat of categories" :key="cat.id">
                <a-checkbox @change="showByCategory(cat.id)">{{ cat.name }} ({{ cat.count_posts }})</a-checkbox>
              </p>
            </div>

            <div>
              <p>Area</p>
              <p v-for="area of areas" :key="area.value">
                <a-checkbox @change="showByArea(area)">{{ area.label }} ({{ area.count }})</a-checkbox>
              </p>
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
              style="height: 800px"
              :items="job_applications"
              item-height="150"
              v-infinite-scroll="handleInfiniteOnLoad"
              :infinite-scroll-disabled="busy"
              :infinite-scroll-distance="10"
            >
              <a-list-item slot-scope="{item}">
                <a-list-item-meta :description="item.title">
                  <a slot="title" :href="item.slug">{{item.title}}</a>
                  <a-avatar slot="avatar" src="https://zos.alipayobjects.com/rmsportal/ODTLcjxAfvqbxHnVXCYX.png" />
                </a-list-item-meta>
                <div>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Adipisci, aliquam autem, beatae consequuntur culpa dolorem dolorum eius facilis fugiat in libero maxime natus nostrum, perspiciatis sapiente vel veniam veritatis vitae.</div>
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

import JOB_APPLICATIONS_QUERY from '~/apollo/queries/allJobApplications.gql';
import JOB_CATEGORIES_ORDER_BY_POSTS_QUERY from '~/apollo/queries/allCategoriesOrderByPosts.gql';

export default {

  apollo: {
    allJobApplications: {
      prefetch: true,
      query: JOB_APPLICATIONS_QUERY,
      variables: {
        offset: this.offset,
        keyword: ''
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
      categories: [],
      areas: [
        { label: 'Area 1', value: 0, count: 476 },
        { label: 'Area 2', value: 1, count: 434 },
        { label: 'Area 3', value: 2, count: 151 },
        { label: 'Area 4', value: 3, count: 269 },
        { label: 'Area 5', value: 4, count: 155 },
        { label: 'Area 6', value: 5, count: 198 },
        { label: 'Area 7', value: 6, count: 331 },
      ],
      job_applications: [],
      perPage: 25,
      offset: 0,
      pagination: {},
      loading: false,
      selectedRowKeys: [],
      searchText: '',
      keyword: '',
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
    async handleInfiniteOnLoad() {
      const tempData = this.job_applications;
      this.loading = true;

      let keyword = this.keyword;
      let offset = (this.job_applications.length > 0 ) ? this.job_applications.length + this.perPage : 0;
      const apolloClient = this.$apollo.provider.defaultClient;

      await apolloClient.query({
        query: JOB_APPLICATIONS_QUERY,
        variables: {
          offset,
          keyword
        }
      }).then(({data}) => {
        this.loading = false;
        if (data.allJobApplications.length > this.perPage) {
          this.$message.warning('No more jobs to show!');
          this.busy = true;
          this.loading = false;
          return
        }

        /*let lastPrevElement = this.job_applications[this.job_applications.length - 1];
        let newElement = data.allJobApplications[data.allJobApplications.length - 1];

        if(lastPrevElement.id === newElement.id) {
          return;
        }
        */
        this.job_applications = this.job_applications.concat(data.allJobApplications);
        console.log(this.job_applications);
        return data
      }).catch((err) => {
        this.loading = false;
        console.log("err: ", err);
      });
    },

    /*async getCategoriesOrderByPosts() {
      const apolloClient = this.$apollo.provider.defaultClient;
      await apolloClient.query({
        query: JOB_CATEGORIES_ORDER_BY_POSTS_QUERY,
        variables: {}
      }).then(({data}) => {
        console.log('categories: ', data.allCategoriesOrderByPosts)
        return data
      }).catch((err) => {
        this.loading = false;
        console.log("err: ", err);
      });
    },*/

    sortMenuClick() {
      console.log('sort menu clicked');
    },

    showOnlyTodayListings() {
      console.log('showing only today\'s listings');
    },

    showByCategory(cat) {
      console.log(cat);
    },

    showByArea(area) {
      console.log(area);
    },

    onSearch() {
      console.log('searched for');
    },

    onSelectChange (selectedRowKeys) {
      console.log('selectedRowKeys changed: ', selectedRowKeys);
      this.selectedRowKeys = selectedRowKeys
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

