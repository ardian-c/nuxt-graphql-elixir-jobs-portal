<template>
<div>
  <a-layout-header style="background: #fff; padding: 0" />
    <a-layout-content style="margin: 0 16px">
      <a-breadcrumb style="margin: 16px 0">
        <a-breadcrumb-item>Home</a-breadcrumb-item>
        <a-breadcrumb-item>Companies</a-breadcrumb-item>
        <a-breadcrumb-item>Create</a-breadcrumb-item>
      </a-breadcrumb>
      <div :style="{ padding: '24px', background: '#fff', minHeight: '360px' }">
          <a-button class="editable-add-btn" @click="handleRedirectBack">Back</a-button>&nbsp;<br />
          <a-row type="flex" justify="space-around" align="middle">
            <a-col :span="10">
              <a-form
                :autoFormCreate="(form) => { this.form = form }"
                @submit.prevent="onSubmitAddCompany"
                class="job-application-form"
              >
                <a-form-item
                  hasFeedback
                  :validateStatus="validName"
                  label="Name"
                  fieldDecoratorId="name"
                  :fieldDecoratorOptions="{rules: [
                    { required: true, message: 'Please enter a name for company.' }]}"
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
                  hasFeedback
                  :validateStatus="validEmail"
                  fieldDecoratorId="email"
                  :fieldDecoratorOptions="{rules: [
                    { required: true, message: 'Please enter an email' }]}"
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
                  <a-button type='primary' htmlType='submit' class='register-form-button'>Create Company
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

import COMPANIES_QUERY from '~/apollo/queries/allCompanies.gql'
import NEW_COMPANY_MUTATION from '~/apollo/mutations/newCompany.gql';
import UPLOAD_COMPANY_LOGO_MUTATION from '~/apollo/mutations/uploadCompanyLogo.gql';

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
    return {
      perPage: 25,
      offset: 0,
      keyword: '',
      submitting: false,
      companyCreated: false,
      errors: false,
      company: {
        name: '',
        address: '',
        email: '',
        phone: '',
      },
      logo: null,
      form: null,
      validName: '',
      validEmail: ''
    }
  },

  watch: {
    'company.name': function(newVal, val) {
        this.validName = (this.company.name.length >= 3) ? 'success' : 'error';
    },

    'company.email': function(newVal, val) {
      this.validEmail = this.isEmail(newVal) ? 'success' : 'error';
    },
  },

  mounted() {
  },

  computed: {

  },

  methods: {

    async onSubmitAddCompany() {
      this.form.validateFields((err, values) => {
        if (err) {
          this.submitting = false;
          this.errors =  true;
        } else {
          this.errors = false;
        }
      });

      if(!this.errors) {
        const formData = new FormData();
        this.submitting = true;
        const input = this.company;

        // formData.append('input', input);
        if(this.logo !== null) {
          formData.append('file', this.logo.originFileObj);
        }

        const res = await this.$apollo.mutate({
          mutation: NEW_COMPANY_MUTATION,
          variables: {
            input
          },
          // update query with new results
          refetchQueries: [{
            query: COMPANIES_QUERY,
            variables: {
              offset: this.offset,
              keyword: this.keyword
            },
          }],
        }).then(({data}) => {
          this.companyCreated = true;
          this.$message.success('Successfully added company!', 3);
          return data
        }).catch((err) => {
          console.log("err: ", err);
          this.errors = true;
          this.$message.error('Something went wrong!', 3);
        });

        if(this.companyCreated && this.logo !== null) {
          const logoUpload = await client.mutate({
            mutation: UPLOAD_COMPANY_LOGO_MUTATION,
            variables: {
              logo: this.logo.originFileObj,
              companyId: res.newCompany.id
            },
            update: (store, { data: { uploadCompanyLogo }}) => {
              try {
                const data = store.readQuery({ query: COMPANIES_QUERY, variables: { offset: this.offset, keyword: this.keyword } });
                console.log('data 22: ', data);
                data.allCompanies.push(uploadCompanyLogo);
                store.writeQuery({ query: COMPANIES_QUERY, data });
              } catch(err) {
                console.log(err);
              }
            }
          }).then(({ data }) => {
            console.log("data: ", data);
          }).catch((err) => {
            this.errors = true;
            console.log("err: ", err);
          });
        }

        if(!this.errors) {
          // window.location.reload();
          this.$router.push({ path: '/backend/admin/companies'});
          setTimeout(function() {
            window.location.reload();
          }, 3000);
        }
      }
    },

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


