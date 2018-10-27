<template>
<div class="edit-company-wrapper">
  <a-layout-header style="background: #fff; padding: 0" />
    <a-layout-content style="margin: 0 16px">
      <a-breadcrumb style="margin: 16px 0">
        <a-breadcrumb-item>Home</a-breadcrumb-item>
        <a-breadcrumb-item>Companies</a-breadcrumb-item>
      </a-breadcrumb>
      <div :style="{ padding: '24px', background: '#fff', minHeight: '360px' }">
          <a-button class="editable-add-btn" @click="handleRedirectBack">Back</a-button>&nbsp;
          <br />
          <a-row type="flex" justify="space-around" align="middle">
            <a-col :span="10">
              <a-form
                :loading="loading"
                :autoFormCreate="(form) => { this.form = form }"
                @submit.prevent="onSubmitEditCompany"
                class="job-application-form"
              >
                <a-form-item
                  label="Name"
                >
                  <a-input
                    type="text"
                    placeholder="company name"
                    v-model="company.name"
                    ref="nameInput">
                    <a-icon v-if="company.name" type="close-circle"/>
                  </a-input>
                </a-form-item>

                <a-form-item
                  label="Address"
                >
                  <a-input
                    type="text"
                    placeholder="company address"
                    v-model="company.address"
                    ref="addressInput">
                    <a-icon slot="prefix" type="environment-o" />
                  </a-input>
                </a-form-item>

                <a-form-item
                  label="Email"
                >
                  <a-input
                    type="email"
                    placeholder="email"
                    v-model="company.email"
                    ref="emailInput">
                    <a-icon slot="prefix" type="mail" />
                    <a-icon v-if="company.email" type="close-circle"/>
                  </a-input>
                </a-form-item>

                <a-form-item
                  label="Phone"
                >
                  <a-input
                    type="text"
                    placeholder="company phone"
                    v-model="company.phone"
                    ref="phoneInput">
                    <a-icon slot="prefix" type="phone" />
                  </a-input>
                </a-form-item>

                <a-form-item
                  label="Company Logo"
                >
                  <div class="dropbox">
                    <a-upload name="file" :multiple="false" action="" @change="handleChange">
                    <a-button>
                      <a-icon type="upload" /> Click to Upload
                    </a-button>
                  </a-upload>
                  </div>
                </a-form-item>

                <a-form-item>
                  <a-button type='primary' htmlType='submit' class='register-form-button'>Update Company
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
import ApolloClient from "apollo-client";
import { InMemoryCache } from "apollo-cache-inmemory";
import { createLink } from "apollo-absinthe-upload-link";

import singleCompanyQuery from '~/apollo/queries/singleCompany.gql';

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
      title: 'Edit Company',
      meta: [
        { hid: 'edit company', name: 'edit company', content: 'Backend | Companies' }
      ]
    }
  },

  apollo: {
    singleCompany: {
      query:  singleCompanyQuery,
      prefetch: ({ route }) => ({ id: route.params.id }),
      variables() {
        return { id: this.$route.params.id }
      },
      result({data}){
        this.loading = true;
        this.company = data.singleCompany;
        this.loading = false;
      }
    }
  },

  data() {
    return {
      loading: false,
      submitting: false,
      companyEdited: false,
      errors: false,
      company: {},
      logo: null,
      form: null,
      validName: '',
      validEmail: ''
    }
  },

  watch: {
  },

  mounted() {
  },

  computed: {

  },

  methods: {
    // async onSubmitEditCompany() {
    //   this.form.validateFields((err, values) => {
    //     if (err) {
    //       this.submitting = false;
    //       this.errors =  true;
    //     } else {
    //       this.errors = false;
    //     }
    //   });

    //   if(!this.errors) {
    //     const formData = new FormData();
    //     this.submitting = true;
    //     const input = this.company;
    //   }
    // },

    handleRedirectBack() {
      this.$router.push({ path: '/backend/admin/companies' });
    },

    handleChange(info) {
      if (info.file.status === 'done') {
        console.log(info.file);
        this.logo = info.file;
      }
    },

    isEmail() {
      var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

      return re.test(this.company.email);
    }
  }
}
</script>

<style>

</style>
