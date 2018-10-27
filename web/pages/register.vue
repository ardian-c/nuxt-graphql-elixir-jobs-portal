<template>
  <div class="container">
    <a-row type="flex" justify="space-around" align="middle">
      <a-col :span="8">
        <a-form
          :autoFormCreate="(form) => { this.form = form }"
          @submit.prevent="onSubmitRegister"
          v-if="!isAuthenticated"
          class="register-form"
        >
          <a-form-item
            hasFeedback
            :validateStatus="validFirstName"
            fieldDecoratorId="firstName"
            :fieldDecoratorOptions="{rules: [
              { required: true, message: 'Please enter your first name' }]}"
          >
            <a-input
              type="text"
              placeholder="first name"
              v-model="register.first_name"
              ref="firstNameInput">
              <a-icon v-if="register.first_name" type="close-circle"/>
            </a-input>
          </a-form-item>

          <a-form-item>
            <a-input
              type="text"
              placeholder="last name"
              v-model="register.last_name"
            ></a-input>
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
              v-model="register.email"
              ref="emailInput">
              <a-icon slot="prefix" type="user" />
              <a-icon v-if="register.email" type="close-circle"/>
            </a-input>
          </a-form-item>

          <a-form-item
            hasFeedback
            :validateStatus="validPassword"
            fieldDecoratorId="password"
            :fieldDecoratorOptions="{ rules: [
                { required: true, message: 'Please enter your password confirmation' },
                { min: 6, message: 'Password should be at least 6 characters.' }
              ]}"
          >
            <a-input
              type='password'
              placeholder="password"
              v-model="register.password"
              ref="passwordInput">
              <a-icon slot="prefix" type="lock" />
              <a-icon v-if="register.password" type="close-circle" />
            </a-input>
          </a-form-item>

          <a-form-item
            hasFeedback
            :validateStatus="validPasswordConfirmation"
            fieldDecoratorId="passwordConfirmation"
            :fieldDecoratorOptions="{ rules: [
                { required: true, message: 'Please enter your password confirmation' },
                { min: 6, message: 'Password confirmation should be the same.' }
              ]}"
          >
            <a-input
              type='password'
              placeholder="confirm password"
              v-model="register.password_confirmation"
              ref="passwordConfirmationInput">
              <a-icon slot="prefix" type="lock" />
              <a-icon v-if="register.password_confirmation" type="close-circle" />
            </a-input>
          </a-form-item>

          <a-form-item>
            <a-button type='primary' htmlType='submit' class='register-form-button'>
              Register
            </a-button>
            Or <nuxt-link to="/login">login now!</nuxt-link>
          </a-form-item>
        </a-form>
      </a-col>
    </a-row>
  </div>
</template>

<script>
  import { Form } from 'ant-design-vue'

  import userCurrentQuery from '../apollo/queries/userCurrent.gql';
  import userRegisterInput from '../apollo/inputs/userRegister.gql';
  import registerMutation from '../apollo/mutations/register.gql'

  export default {
    head() {
      return {
        title: 'Register'
      }
    },
    components: { },
    data() {
      return {
        isAuthenticated: false,
        submitting: false,
        errors: false,
        register: {
          first_name: '',
          last_name: '',
          email: '',
          password: '',
          password_confirmation: ''
        },
        form: null,
        validEmail: '',
        validPassword: '',
        validPasswordConfirmation: '',
        validFirstName: ''
      }
    },

    watch: {
      'register.first_name': function(newVal, val) {
        this.validFirstName = (this.register.first_name.length >= 3) ? 'success' : 'error';
      },

      'register.email': function(newVal, val) {
        this.validEmail = this.isEmail(newVal) ? 'success' : 'error';
      },

      'register.password': function(newVal, val) {
        this.validPassword = this.register.password.length >= 6 ? 'success' : 'error';
      },

      'register.password_confirmation': function(newVal, val) {
        this.validPasswordConfirmation = (this.register.password_confirmation == this.register.password) ? 'success' : 'error';
      }
    },

    computed: {

    },

    methods: {
      async onSubmitRegister() {
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
          const input = this.register;
          const apolloClient = this.$apollo.provider.defaultClient;

          try {
            const hide = this.$message.loading('Submitting..', 0);
            setTimeout(hide, 1000);
            const res = await this.$apollo.mutate({
              mutation: registerMutation,
              variables: {
                input
              }
            }).then(({data}) => {
              console.log("Data: ", data);
              this.$message.success('Successfully registered!', 3);
              return data.register
            }).catch((err) => {
              console.log("err: ", err);
              this.$message.error('Something went wrong!', 3);
            });

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

            this.$router.push({ path: 'backend/dashboard' });

            // redirect to dashboard
          } catch (e) {
            console.error(e);
            this.$message.error('Something went wrgon!', 3);
            this.submitting = false;
          }
        }
      },

      isEmail() {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

        return re.test(this.register.email);
      }
    }
  }
</script>

<style>

</style>
