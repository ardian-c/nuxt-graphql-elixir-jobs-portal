<template>
<div class="edit-company-wrapper">
  <a-layout-header style="background: #fff; padding: 0" />
    <a-layout-content style="margin: 0 16px">
      <a-breadcrumb style="margin: 16px 0">
        <a-breadcrumb-item>Home</a-breadcrumb-item>
        <a-breadcrumb-item>Categories</a-breadcrumb-item>
      </a-breadcrumb>
      <div :style="{ padding: '24px', background: '#fff', minHeight: '360px' }">
          <a-button class="editable-add-btn" @click="handleRedirectBack">Back</a-button>&nbsp;
          <br />
          <a-row type="flex" justify="space-around" align="middle">
            <a-col :span="10">
              <a-form
                :loading="loading"
                :autoFormCreate="(form) => { this.form = form }"
                @submit.prevent="onSubmitEditCategory"
                class="job-application-form"
              >
                <a-form-item
                  label="Name"
                >
                  <a-input
                    type="text"
                    placeholder="category name"
                    v-model="category.name"
                    ref="nameInput">
                    <a-icon v-if="category.name" type="close-circle"/>
                  </a-input>
                </a-form-item>

                <a-form-item
                  label="Description"
                >
                  <a-input
                    type="text"
                    placeholder="category description"
                    v-model="category.description"
                    ref="descriptionInput">
                  </a-input>
                </a-form-item>

                <a-form-item>
                  <a-button type='primary' htmlType='submit' class='register-form-button'>Update Category
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

import SINGLE_CATEGORY_QUERY from '~/apollo/queries/singleCategory.gql';

export default {
  layout: 'backend',

  head () {
    return {
      title: 'Edit Category',
      meta: [
        { hid: 'edit category', name: 'edit category', content: 'Backend | Categories' }
      ]
    }
  },

  apollo: {
    singleCategory: {
      query:  SINGLE_CATEGORY_QUERY,
      prefetch: ({ route }) => ({ id: route.params.id }),
      variables() {
        return { id: this.$route.params.id }
      },
      result({data}){
        console.log('data: ', data);
        this.loading = true;
        this.category = data.singleCategory;
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
      category: {},
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
      this.$router.push({ path: '/backend/admin/categories' });
    },

    handleChange(info) {
      if (info.file.status === 'done') {
        console.log(info.file);
        this.logo = info.file;
      }
    }
  }
}
</script>

<style>

</style>
