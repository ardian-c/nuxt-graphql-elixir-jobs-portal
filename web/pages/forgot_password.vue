<template>
  <div class="container">
    <a-row type="flex" justify="space-around" align="middle">
      <a-col :span="8">
        <a-form
          :autoFormCreate="(form)=>{this.form = form}"
          @submit.prevent="onSubmitForgotPassword"
          v-if="!isAuthenticated"
          class="forgot-password-form"
        >
          <a-form-item
            hasFeedback
            :validateStatus="validEmail"
            fieldDecoratorId="email"
            :fieldDecoratorOptions="{rules: [
              { required: true, message: 'Please enter an email' }]}"
          >
            <a-input
              required="true"
              type="email"
              placeholder="email"
              v-model="credentials.email"
              ref="emailInput">
              <a-icon slot="prefix" type="user" />
              <a-icon v-if="credentials.email" type="close-circle"/>
            </a-input>
          </a-form-item>

          <a-form-item>
            <a-button
              :loading="submitting"
              type='primary'
              htmlType='submit'
              class='login-form-button'>
              Reset Password
            </a-button>
            Or <nuxt-link to="/login">login now!</nuxt-link>
          </a-form-item>
        </a-form>
      </a-col>
    </a-row>
  </div>
</template>

<script>
  import loginMutation from '../apollo/mutations/login.gql';

  import { Form } from 'ant-design-vue'

  export default {
    head() {
      return {
        title: 'Forgot Password'
      }
    },

    components: { },

    data() {
      return {
        isAuthenticated: false,
        submitting: false,
        errors: false,
        success: null,
        credentials: {
          email: '',
        },
        form: null,
        validEmail: '',
        validPassword: ''
      }
    },

    mounted() {
      this.isAuthenticated = !!this.$apolloHelpers.getToken();
    },

    watch: {
      'credentials.email': function(newVal, val) {
        this.validEmail = this.isEmail(newVal) ? 'success' : 'error';
      },
    },

    computed: {

    },

    methods: {
      async onSubmitForgotPassword(e) {
        this.form.validateFields((err, values) => {
          if (err) {
            this.submitting = false;
            this.errors =  true;
          } else {
            this.errors = false;
          }
        });

        if(!this.errors) {
          this.submitting = true;
          const credentials = this.credentials;
          try {
            const res = await this.$apollo.mutate({
              mutation: loginMutation,
              variables: credentials
            }).then(({data}) => data /*&& data.authenticateUser*/);

            await this.$apolloHelpers.onLogin(res.token, undefined, 7);

            this.success = res;
            this.isAuthenticated = true;
            this.submitting = false;
          } catch (e) {
            console.error(e);
            this.submitting = false;
          }
        }
      },

      async onLogout() {
        await this.$apolloHelpers.onLogout();
        this.isAuthenticated = false;
      },

      isEmail() {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

        return re.test(this.credentials.email);
      }
    }
  }
</script>

<style>

</style>
