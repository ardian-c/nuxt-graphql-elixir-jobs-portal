<template>
  <div class="container">
      <a-row type="flex" justify="space-around" align="middle">
        <a-col :span="8">
          <a-form
            :autoFormCreate="(form)=>{this.form = form}"
            @submit.prevent="onSubmitLogin"
            v-if="!isAuthenticated"
            class="login-form"
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

            <a-form-item
              hasFeedback
              :validateStatus="validPassword"
              fieldDecoratorId="password"
              :fieldDecoratorOptions="{ rules: [
                { required: true, message: 'Please enter your password' },
                { min: 6, message: 'Password should be at least 6 characters.' }
              ]}"
            >
              <a-input
                required="true"
                type='password'
                placeholder="password"
                v-model="credentials.password"
                ref="passwordInput">
                <a-icon slot="prefix" type="lock" />
                <a-icon v-if="credentials.password" type="close-circle" />
              </a-input>
            </a-form-item>

            <a-form-item>

              <a-checkbox>Remember me</a-checkbox>

              <nuxt-link to="/forgot-password" class='login-form-forgot'>Forgot Password</nuxt-link>

              <a-button
                :loading="submitting"
                type='primary'
                htmlType='submit'
                class='login-form-button'>
                Log in
              </a-button>
              Or <nuxt-link to="/register">register now!</nuxt-link>
            </a-form-item>
          </a-form>
        </a-col>
      </a-row>
    </div>
</template>

<script>
  import loginMutation from '../apollo/mutations/login.gql';
  import userCurrentQuery from '../apollo/queries/userCurrent.gql';

  import { Form } from 'ant-design-vue'

  export default {
    head() {
      return {
        title: 'Login'
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
          password: '',
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

      'credentials.password': function(newVal, val) {
        this.validPassword = this.credentials.password.length >= 6 ? 'success' : 'error';
      }
    },

    computed: {

    },

    methods: {
      async onSubmitLogin(e) {
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
          const apolloClient = this.$apollo.provider.defaultClient;

          try {
              const res = await this.$apollo.mutate({
                mutation: loginMutation,
                variables: credentials
              }).then(({data}) => data.login /*&& data.authenticateUser*/);

              const { user }  = res;

              await this.$apolloHelpers.onLogin(res.token, undefined, 7);

              apolloClient.writeQuery({
              query: userCurrentQuery,
                data: {
                  userCurrent: res.user
                }
              });

              this.success = res;
              this.isAuthenticated = true;
              this.submitting = false;

              if(user.is_admin) {
                this.$router.push({ path: 'backend/admin/dashboard' });
              } else {
                this.$router.push({ path: 'backend/dashboard' });
              }
            } catch (e) {
              console.error(e);
              this.$message.error('Unauthorized, invalid credentials.', 2);
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
