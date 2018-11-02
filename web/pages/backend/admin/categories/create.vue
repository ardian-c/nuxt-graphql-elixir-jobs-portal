<template>
<div>
  <a-layout-header style="background: #fff; padding: 0" />
    <a-layout-content style="margin: 0 16px">
      <a-breadcrumb style="margin: 16px 0">
        <a-breadcrumb-item>Home</a-breadcrumb-item>
        <a-breadcrumb-item>Categories</a-breadcrumb-item>
        <a-breadcrumb-item>Create</a-breadcrumb-item>
      </a-breadcrumb>
      <div :style="{ padding: '24px', background: '#fff', minHeight: '360px' }">
          <a-button class="editable-add-btn" @click="handleRedirectBack">Back</a-button>&nbsp;<br />
          <a-row type="flex" justify="space-around" align="middle">
            <a-col :span="10">
              <a-form
                :autoFormCreate="(form) => { this.form = form }"
                @submit.prevent="onSubmitAddCategory"
                class="category-form"
              >
                <a-form-item
                  hasFeedback
                  :validateStatus="validName"
                  label="Name"
                  fieldDecoratorId="name"
                  :fieldDecoratorOptions="{rules: [
                    { required: true, message: 'Please enter a name for category.' }]}"
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
                    ref="addressInput">
                  </a-input>
                </a-form-item>

                <a-form-item>
                  <a-button type='primary' htmlType='submit' class='register-form-button'>Create Category
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
import ALL_CATEGORIES_QUERY from '~/apollo/queries/allCategories.gql';
import newCategoryMutation from '~/apollo/mutations/newCategory.gql';

export default {
  layout: 'backend',

  head () {
    return {
      title: 'New Category',
      meta: [
        { hid: 'categories', name: 'categories', content: 'Backend | Categories' }
      ]
    }
  },

  data() {
    return {
      submitting: false,
      categoryCreated: false,
      errors: false,
      category: {
        name: '',
        description: '',
      },
      form: null,
      validName: '',
    }
  },

  watch: {
    'category.name': function(newVal, val) {
        this.validName = (this.category.name.length >= 3) ? 'success' : 'error';
    },
  },

  mounted() {
  },

  computed: {

  },

  methods: {

    async onSubmitAddCategory() {
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
        const input = this.category;

        console.log('input: ', input);

        const res = await this.$apollo.mutate({
          mutation: newCategoryMutation,
          variables: {
            input
          }
        }).then(({data}) => {
          this.categoryCreated = true;
          this.$message.success('Successfully added category!', 3);
          return data
        }).catch((err) => {
          console.log("err: ", err);
          this.errors = true;
          this.$message.error('Something went wrong!', 3);
        });

        if(!this.errors) {
          const res = await this.$apollo.query({
            query: ALL_CATEGORIES_QUERY,
            variables: {
              offset: 0,
              keyword: ''
            }
          }).then(({data}) => {
            return data
          }).catch((err) => {
            console.log("err: ", err);
          });

          this.$bus.$emit('category-added', res);
          this.$router.push({ path: '/backend/admin/categories' });
        }
      }
    },

    handleRedirectBack() {
      this.$router.push({ path: '/backend/admin/categories' });
    }
  }
}
</script>

<style>

</style>


