<template>
<div>
  <a-layout-header style="background: #fff; padding: 0" />
    <a-layout-content style="margin: 0 16px">
      <a-breadcrumb style="margin: 16px 0">
        <a-breadcrumb-item>Home</a-breadcrumb-item>
        <a-breadcrumb-item>Job Applications</a-breadcrumb-item>
        <a-breadcrumb-item>Create</a-breadcrumb-item>
      </a-breadcrumb>
      <div :style="{ padding: '24px', background: '#fff', minHeight: '360px' }">
          <a-row type="flex" justify="space-around" align="middle">
            <a-col :span="14">
              <a-form
                :autoFormCreate="(form) => { this.form = form }"
                @submit.prevent="onSubmitAddNewApplication"
                class="job-application-form"
              >
                <a-form-item
                  hasFeedback
                  :validateStatus="validTitle"
                  label="Title"
                  fieldDecoratorId="title"
                  :fieldDecoratorOptions="{rules: [
                    { required: true, message: 'Please enter a title for job application.' }]}"
                >
                  <a-input
                    type="text"
                    placeholder="job application title"
                    v-model="job_application.title"
                    ref="titleInput">
                    <a-icon v-if="job_application.title" type="close-circle"/>
                  </a-input>
                </a-form-item>

                <div class="quill-editor"
                  :content="job_application.content"
                  @change="onEditorChange($event)"
                  @blur="onEditorBlur($event)"
                  @focus="onEditorFocus($event)"
                  @ready="onEditorReady($event)"
                  v-quill:myQuillEditor="editorOption">
                </div>

                <a-form-item
                  label="Address"
                >
                  <a-input
                    type="text"
                    placeholder="job address"
                    v-model="job_application.address"
                    ref="addressInput">
                  </a-input>
                </a-form-item>

                <a-form-item
                  hasFeedback
                  label="Status"
                >
                  <a-select
                  v-model="job_application.status"
                  ref="statusInput">
                    <a-select-option
                    v-for="(s, idx) in statuses"
                    :key="idx"
                    :value="s">{{ s }}</a-select-option>
                  </a-select>
                </a-form-item>

                <a-form-item
                  hasFeedback
                  label="Priority"
                >
                  <a-select
                  v-model="job_application.priority"
                  ref="priorityInput">
                    <a-select-option
                    v-for="(priority, idx) in priorities"
                    :key="idx"
                    :value="priority">{{ priority }}</a-select-option>
                  </a-select>
                </a-form-item>

                <a-form-item
                  label="Source"
                >
                  <a-input
                    type="text"
                    placeholder="job source"
                    v-model="job_application.source"
                    ref="sourceInput">
                  </a-input>
                </a-form-item>

                <a-row>
                  <a-col :span="12">
                    <a-form-item
                      label='Application will show until (date)'
                    >
                      <a-date-picker format="YYYY-MM-DD"
                        :disabledDate="disabledDate"
                        v-model="ends_date"
                        style="width: 90%" />
                    </a-form-item>
                  </a-col>

                  <a-col :span="12">
                    <a-form-item
                      label="Application will show until (time)"
                    >
                    <a-time-picker
                      format="HH:mm:ss"
                      style="width: 100%"
                      v-model="ends_date_time"
                    />
                    </a-form-item>
                  </a-col>
                </a-row>

                <a-row><a-switch
                  v-model="job_application.is_scheduled" /> Publish the job application later? Pick a publish time. </a-row>

                <a-row v-if="job_application.is_scheduled">
                  <a-col :span="12">
                    <a-form-item
                      label='Publish Date'
                    >
                    <a-date-picker format="YYYY-MM-DD"
                      :disabledDate="disabledDate"
                      v-model="publish_date"
                      style="width: 90%" />
                    </a-form-item>
                  </a-col>
                  <a-col :span="12">
                    <a-form-item
                      label='Publish Time'
                    >
                      <a-time-picker
                      format="HH:mm:ss"
                      style="width: 100%"
                      v-model="publish_time"
                      />
                    </a-form-item>
                  </a-col>
                </a-row>
                <br />

                <a-form-item
                  label="Company"
                  v-if="companies.length > 0"
                >
                  <a-select
                    showSearch
                    placeholder='Select owner of the job application'
                    v-model="job_application.company_id"
                    :filterOption="filterCompanyOptions"
                  >
                    <a-select-option v-for="(company, idx) in companies" :key="'company-'+idx" :value='company.id'>{{ company.name }}</a-select-option>
                  </a-select>
                </a-form-item>

                <a-form-item
                  label="Categories"
                >
                  <a-select
                    mode="multiple"
                    labelInValue
                    :value="job_application.categories"
                    placeholder="Select categories"
                    :filterOption="false"
                    @search="findCategoryByNameOrDescription"
                    @change="handleCategoriesSelectChange"
                    :notFoundContent="fetching ? undefined : null"
                  >
                    <a-spin v-if="fetching" slot="notFoundContent" size="small"/>
                    <a-select-option v-for="d in foundCategories" :key="d.value">{{d.text}}</a-select-option>
                  </a-select>
                  <!-- <a-select
                    mode='multiple'
                    placeholder='Job application categories'
                    @change="handleCategoriesSelectChange"
                  >
                    <a-select-option
                      v-for="cat in categories"
                      :key="cat.id"
                      :value='cat.id'
                    >{{ cat.description }}</a-select-option>
                  </a-select> -->
                </a-form-item>

                <a-form-item
                  label="Upload documents related to job application"
                >
                  <div class="dropbox">
                    <a-upload
                      name="file"
                      :accept="'image/*,.doc,.pdf'"
                      :multiple="true"
                      action=""
                      @remove="handleRemoveFile"
                      @change="handleChange">
                    <a-button>
                      <a-icon type="upload" /> Click to Upload
                    </a-button>
                  </a-upload>
                  </div>
                </a-form-item>

                <a-form-item>
                  <a-button type='primary' htmlType='submit' class='register-form-button'>
                    {{ (!job_application.is_scheduled) ? 'Publish' : 'Schedule for later posting' }}
                  </a-button>
                </a-form-item>
              </a-form>
            </a-col>
          </a-row>
      </div>
    </a-layout-content>
</div>
</template>

<script>
import moment from 'moment';
import debounce from 'lodash/debounce';

import ApolloClient from "apollo-client";
import { InMemoryCache } from "apollo-cache-inmemory";
import { createLink } from "apollo-absinthe-upload-link";

import SINGLE_CATEGORY_BY_NAME_OR_DESCRIPTION_QUERY from '~/apollo/queries/singleCategoryByNameOrDescription.gql';
import ALL_COMPANIES_QUERY from '~/apollo/queries/allCompaniesNoPagination.gql';
import ALL_CATEGORIES_QUERY from '~/apollo/queries/allCategoriesNoPagination.gql';
import NEW_JOB_APPLICATION_MUTATION from '~/apollo/mutations/newJobApplication.gql';

const client = new ApolloClient({
  link: createLink({
    uri: process.env.HTTP_ENDPOINT || 'http://localhost:4000/api/v1/graphql'
  }),
  cache: new InMemoryCache()
});

export default {
  layout: 'backend',

  head () {
    return {
      title: 'New Job Application ',
      meta: [
        { hid: 'job applications', name: 'job applications', content: 'Backend | Job Applications' }
      ]
    }
  },

  data() {
    this.lastFetchId = 0;
    this.findCategoryByNameOrDescription = debounce(this.findCategoryByNameOrDescription, 800);

    return {
      submitting: false,
      errors: false,
      fetching: false,
      editorOption: {
        // some quill options
        modules: {
          toolbar: [
            ['bold', 'italic', 'underline', 'strike'],
            ['blockquote', 'code-block'],
            [{ 'header': 1 }, { 'header': 2 }],
            [{ 'list': 'ordered' }, { 'list': 'bullet' }],
            [{ 'script': 'sub' }, { 'script': 'super' }],
            [{ 'indent': '-1' }, { 'indent': '+1' }],
            [{ 'direction': 'rtl' }],
            [{ 'size': ['small', false, 'large', 'huge'] }],
            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
            [{ 'font': [] }],
            [{ 'color': [] }, { 'background': [] }],
            [{ 'align': [] }],
            ['clean'],
          ]
        }
      },
      ends_date: moment(),
      ends_date_time: moment(),
      publish_date: moment(),
      publish_time: moment(),
      statuses: ['publish', 'draft', 'trashed'],
      priorities: ['lowest priority (1)', 'medium priority (2)', 'high priority (3)'],
      companies: [],
      foundCategories: [],
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
      form: null,
      documents: [],
      validTitle: '',
    }
  },

  watch: {
    'job_application.title': function(newVal, val) {
      this.validTitle = (this.job_application.title.length >= 3) ? 'success' : 'error';
      this.job_application.slug = this.sanitizeTitle(this.job_application.title);
    }
  },

  mounted() {
    // this.getCategories();
    this.getCompanies();
  },

  computed: {
    'job_application.ends_at': function() {
      var ends_at = this.ends_date.toString();
      return ends_at;
    },
    'job_application.publish_date': function() {
      var publish_date = this.publish_date.toString() + ' ' + this.publish_time.toString();
      return publish_date;
    }
  },

  methods: {
    moment,

    disabledDate(current) {
      // Can not select days before today and today
      return current && current <= moment().endOf('day');
    },

    handleRemoveFile(file) {
      this.documents.forEach((f, idx) => {
        if(f.uid == file.uid) {
          this.documents.splice(idx, 1);
        }
      });
    },

    async findCategoryByNameOrDescription(value) {
      if(value.length < 2) { return; }
      this.lastFetchId += 1;
      const fetchId = this.lastFetchId;
      this.foundCategories = [];
      this.fetching = true;
      const apolloClient = this.$apollo.provider.defaultClient;
      const category = await apolloClient.query({
        query: SINGLE_CATEGORY_BY_NAME_OR_DESCRIPTION_QUERY,
        variables: {
          keyword: value
        }
      }).then(({ data }) => {
        if (fetchId !== this.lastFetchId) { // for fetch callback order
          return;
        }

        data.singleCategoryByNameOrDescription.forEach((data, idx) => {
          this.foundCategories.push({
            text: data.name,
            value: data.id
          });
        });

        this.fetching = false;
      }).catch((err) => {
        this.fetching = false;
      });
    },

    async getCompanies() {
      const apolloClient = this.$apollo.provider.defaultClient;
      const companies = await apolloClient.query({
        query: ALL_COMPANIES_QUERY,
        variables: {}
      }).then(({ data}) => {
        this.companies = data.allCompaniesNoPagination;
      }).catch((err) => {
        console.log('err: ', err);
      });
    },

    async getCategories() {
      const apolloClient = this.$apollo.provider.defaultClient;
      const categories = await apolloClient.query({
        query: ALL_CATEGORIES_QUERY,
        variables: {}
      }).then(({data}) => {
        this.job_application.categories = data.allCategoriesNoPagination;
      }).catch((err) => {
        console.log('err: ', err);
      });
    },

    handleChange(info) {
      if (info.file.status === 'done') {
        // console.log(info.file);
        this.documents.push(info.file.originFileObj);
      }
    },

    handleTimepickerChange(time, timeString) {
      // console.log(this.job_application.published_at);
      // console.log('time string: ', timeString);
    },

    handleCategoriesSelectChange(value) {
        let tmp = {};
        tmp.id = value.key;
        tmp.name = value.label;

        Object.assign(this, {
          foundCategories: [],
          fetching: false,
        });

        Object.assign(this.job_application, {
          categories: value
        });
    },

    async onSubmitAddNewApplication() {
      this.form.validateFields((err, values) => {
        if (err) {
          this.submitting = false;
          this.errors =  true;
          this.$message.error('There are some errors with the form data. Please fill the required fields!', 3);
        } else {
          this.errors = false;
        }
      });

      if(!this.errors && this.job_application.content.length <= 20) {
        this.$message.warning('Attention! The content should be at least 20 characters long.');
        this.errors = true;
        return;
      }

      if(!this.errors) {
        this.submitting = true;

        const formData = new FormData();
        let categories = [];
        let status = 1;
        let priority = 1;
        let input = this.job_application;

        switch(this.job_application.priority){
          case 'lowest priority (1)':
            priority = 1;
            break;

          case 'medium priority (2)':
            priority = 2;
            break;

          case 'high priority (3)':
            priority = 3;
            break;

          default:
            priority = 1;
        }

        switch(this.job_application.status) {
          case 'publish':
            status = 1;
            break;

          case 'draft':
            status = 2;
            break;

          case 'trashed':
            status = 3;
            break;

          default:
            status = 1;
        }

        input.priority = priority;
        input.status = status;
        input.ends_at = this.ends_date.format('YYYY-MM-DD').toString() + ' ' + this.ends_date_time.format('HH:mm:ss').toString();
        input.published_at = this.publish_date.format('YYYY-MM-DD').toString() + ' ' + this.publish_time.format('HH:mm:ss').toString();

        input.categories.forEach((cat, idx) => {
          categories.push(cat.key);
        });


        input.categories = categories;

        // Object.keys(input).forEach(key => formData.append(key, object[key]));

        const res = await client.mutate({
          mutation: NEW_JOB_APPLICATION_MUTATION,
          variables: {
            input,
            documents: this.documents
          },
        }).then(({ data }) => {
          this.$message.success('Job application added successfully!');

          // window.location.reload();
          this.$router.push({ path: '/backend/admin/job-applications'});
          setTimeout(function() {
            window.location.reload();
          }, 3000);

        }).catch((err) => {
          console.log('err: ', err);
        });
      }
    },

    onEditorBlur(editor) {
      // console.log('editor blur!', editor)
    },
    onEditorFocus(editor) {
      // console.log('editor focus!', editor)
    },
    onEditorReady(editor) {
      // console.log('editor ready!', editor)
    },
    onEditorChange({ editor, html, text }) {
      // console.log('editor change!', editor, html, text)
      this.job_application.content = html
    },

    filterCompanyOptions(input, option) {
        return option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
    },

    // helper methods
    sanitizeTitle: function(title) {
      var random = Math.floor(Date.now() / 1000);
      var slug = "";
      // Change to lower case
      var titleLower = title.toLowerCase();
      // Letter "e"
      slug = titleLower.replace(/e|é|è|ẽ|ë|ẻ|ẹ|ê|ế|ề|ễ|ể|ệ/gi, 'e');
      // Letter "a"
      slug = slug.replace(/a|á|à|ã|ả|ạ|ă|ắ|ằ|ẵ|ẳ|ặ|â|ấ|ầ|ẫ|ẩ|ậ/gi, 'a');
      // Letter "o"
      slug = slug.replace(/o|ó|ò|õ|ỏ|ọ|ô|ố|ồ|ỗ|ổ|ộ|ơ|ớ|ờ|ỡ|ở|ợ/gi, 'o');
      // Letter "u"
      slug = slug.replace(/u|ú|ù|ũ|ủ|ụ|ư|ứ|ừ|ữ|ử|ự/gi, 'u');
      // Letter "d"
      slug = slug.replace(/đ/gi, 'd');
      // letter 'ç'
      slug = slug.replace(/ç/gi, 'c')

      // Trim the last whitespace
      slug = slug.replace(/\s*$/g, '');
      // Change whitespace to "-"
      slug = slug.replace(/\s+/g, '-');

      return slug + '-' + random;
    }
  }
}
</script>

<style lang="scss" scoped>
.quill-code {
    border: none;
    height: auto;
    min-height: 400px;
    > code {
      width: 100%;
      margin: 0;
      padding: 1rem;
      border: 1px solid #ccc;
      border-top: none;
      border-radius: 0;
      height: 10rem;
      overflow-y: auto;
      resize: vertical;
    }
  }
</style>


