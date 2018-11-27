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

import SINGLE_JOB_APPLICATION_QUERY from '~/apollo/queries/singleJobApplication.gql';

const client = new ApolloClient({
  link: createLink({
    uri: process.env.HTTP_ENDPOINT || 'http://localhost:4000/api/v1/graphql'
  }),
  cache: new InMemoryCache()
});

export default {
  layout: 'backend',

  head() {
    return {
      title: 'Edit Job Application',
      meta: [
        { hid: 'edit job application', name: 'edit job application', content: 'Backend | Job Applications'}
      ]
    }
  },

  apollo: {
    singleJobApplication: {
      query: SINGLE_JOB_APPLICATION_QUERY,
      prefetch: ({ route }) => ({ id: route.params.id }),
      variables() {
        return { id: this.$route.params.id }
      },
      result({ data }) {
        console.log('data: ', data);

      }
    }
  },

  data() {
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
  }
}
</script>

<style>

</style>
