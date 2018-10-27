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
            <strong>19 698</strong> positions in <strong>8,996</strong> ads
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
              <p v-for="cat of categories" :key="cat.value">
                <a-checkbox @change="showByCategory(cat)">{{ cat.label }} ({{ cat.count }})</a-checkbox>
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

        <a-list>
            <virtual-scroller
              style="height: 800px"
              :items="data"
              item-height="100"
              v-infinite-scroll="handleInfiniteOnLoad"
              :infinite-scroll-disabled="busy"
              :infinite-scroll-distance="5"
            >
              <a-list-item slot-scope="{item}">
                <a-list-item-meta :description="item.email">
                  <a slot="title" :href="item.href">{{item.name.last}}</a>
                  <a-avatar slot="avatar" src="https://zos.alipayobjects.com/rmsportal/ODTLcjxAfvqbxHnVXCYX.png" />
                </a-list-item-meta>
                <div>Content {{item.index}}</div>
              </a-list-item>
            </virtual-scroller>
            <a-spin v-if="loading"  class="jobs-loading" />
        </a-list>
      </div>
    </div>
  </div>
</template>

<script>

import reqwest from 'reqwest'

const fakeDataUrl = 'https://randomuser.me/api/?results=10&inc=name,gender,email,nat&noinfo'

export default {

  directives: {
  },

  components: {

  },

  data() {
    return {
      loading: false,
      busy: false,
      current: ['home'],
      categories: [
        { label: 'Category 1', value: 0, count: 20 },
        { label: 'Category 2', value: 1, count: 84 },
        { label: 'Category 3', value: 2, count: 81 },
        { label: 'Category 4', value: 3, count: 149 },
        { label: 'Category 5', value: 4, count: 155 },
        { label: 'Category 6', value: 5, count: 198 },
        { label: 'Category 7', value: 6, count: 73 },
      ],
      areas: [
        { label: 'Area 1', value: 0, count: 476 },
        { label: 'Area 2', value: 1, count: 434 },
        { label: 'Area 3', value: 2, count: 151 },
        { label: 'Area 4', value: 3, count: 269 },
        { label: 'Area 5', value: 4, count: 155 },
        { label: 'Area 6', value: 5, count: 198 },
        { label: 'Area 7', value: 6, count: 331 },
      ],
      jobs: [
        {
          company_logo: 'https://images.finncdn.no/dynamic/320w/2018/9/vertical-1/12/5/109/230/375_929355925.png',
          company_name: 'Proventus AS',
          title: 'Full-stack .NET develops with focus on front-end',
          position: 'System Developer',
          place: 'Kolbotn',
          short_description: 'We are constantly getting new and exciting assignments and we are now searching for more full-stack developer e on .Net platform , with particular focus on the front end of the development. We develop solutions for large companies, municipalities and organizations and many of our consultants are central to the development of business critical applications and solutions.',
          open_positions: 1,
          type: 'paid',
          created_at: '2018-09-18 23:00:00',
          start_date: 'ASAP',
          duration: ''
        },
        {
          company_logo: 'https://images.finncdn.no/dynamic/default/logo/2018/9/16/3/129/431/413_248977054.png',
          company_name: 'Mediabooster AS',
          title: 'We open the doors for new talent in Content & Performance Marketing',
          position: 'Content & Performance Marketing Specialist',
          place: 'Kolbotn',
          short_description: 'With us in Mediabooster we work with most types of projects within; Content, performance, analysis, automation, brand and concept development in Google, Facebook, Instagram and web solutions. Today, we are 5 professional specialists who dig what we are working on, but we are growing fast and need great talents who can become our new colleagues in the future. This is a golden opportunity for students who want to secure you a 100% position in the future!',
          open_positions: 2,
          type: '',
          created_at: '2018-09-18 23:00:00',
          start_date: 'URGENTLY',
          duration: ''
        },
        {
          company_logo: 'https://images.finncdn.no/dynamic/1600w/logo/result/413162945/iad_178711011333537950611-12-2012_09-31-30.png',
          company_name: 'Health Bergen - Neurological department, Spinaleininga',
          title: 'Available full time fixed positions as authorized nurses',
          position: 'Nurse',
          place: 'Kolbotn',
          short_description: 'Health Bergen - Neurological department has 12 beds and accommodates patients with spinal cord injury from Helseregion Vest to primary rehabilitation and lifelong follow-up. Most patients are men who have back and neck fractures. We take care of both newly injured and patients for follow-up. Eininga was successful in the trivelege local, with many technical aids that make it well suited for our user group and the ones they add. ',
          open_positions: 5,
          type: '',
          created_at: '2018-09-18 23:00:00',
          start_date: '14/10/2018',
          duration: ''
        },
        {
          company_logo: 'https://images.finncdn.no/dynamic/1600w/logo/object/1113910054/iad_8967583613873279062mg.png',
          company_name: 'Mester Grønn AS',
          title: 'Store Shopper - Master Green Square - Extra Aid',
          position: 'Retail ',
          place: 'Kolbotn',
          short_description: 'We need your sales talent to create results. Our customers will get quality and "the little extra" in terms of things they need, advice and tips, so it\'s important that you are committed and committed to providing good service. ',
          open_positions: 1,
          type: 'paid',
          created_at: '2018-09-18 23:00:00',
          start_date: '09/24/2018',
          duration: ''
        },
        {
          company_logo: 'https://images.finncdn.no/dynamic/320w/logo/result/1549590221/iad_735628561398960251kommunelogo_sort-hvit-gul.png',
          company_name: 'Oppegård municipality',
          title: 'We open the doors for new talent in Content & Performance Marketing',
          position: 'Advisor - HR',
          place: 'Kolbotn',
          short_description: 'The kindergarten in Oppegård municipality plays and teaches every day about 1,600 children, and we are committed to the best start of the training course as possible. That\'s where you come in!',
          open_positions: 1,
          type: '',
          created_at: '2018-09-18 23:00:00',
          start_date: '08/10/2018',
          duration: ''
        },
      ],
      data: []
    }
  },

  beforeMount () {
    this.getData((res) => {
      this.data = res.results.map((item, index) => ({ ...item, index }))
    })
  },

  mounted () {

  },

  methods: {
    getData  (callback) {
      reqwest({
        url: fakeDataUrl,
        type: 'json',
        method: 'get',
        contentType: 'application/json',
        success: (res) => {
          console.log(res)
          callback(res)
        },
      })
    },

    handleInfiniteOnLoad() {
      const data = this.data

      this.loading = true
      if (data.length > 100) {
        this.$message.warning('No more jobs to show!')
        this.busy = true
        this.loading = false
        return
      }
      this.getData((res) => {
        this.data = data.concat(res.results).map((item, index) => ({ ...item, index }))
        this.loading = false
      })
    },

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

