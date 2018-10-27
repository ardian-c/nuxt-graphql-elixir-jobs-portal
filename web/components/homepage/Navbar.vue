<template>
  <a-layout-header>
    <div class="container header-wrapper">
      <a-row>
        <a-col :span="4">
          <div class="logo">
            <nuxt-link to="/"><img src="~/assets/images/logo.png" alt="N'punë" /></nuxt-link>
          </div>
        </a-col>
        <a-col :span="10" :offset="4">
          <a-row type="flex" justify="end">
            <a-menu
              class="header-menu-right"
              v-model="current"
              mode="horizontal"
            >
              <a-menu-item key="home">
                <nuxt-link to="/"><a-icon type="home" /> Home</nuxt-link>
              </a-menu-item>

              <a-menu-item key="jobs">
                <nuxt-link to="/">
                  <a-icon type="notification" /> Jobs
                </nuxt-link>
              </a-menu-item>

              <!--<a-menu-item key="about">
                <a-icon type="compass" /> About Us
              </a-menu-item>-->

              <a-menu-item key="contact">
                <nuxt-link to="/contact"><a-icon type="compass" /> Contact</nuxt-link>
              </a-menu-item>
            </a-menu>
          </a-row>
        </a-col>

        <a-col :span="6">
          <a-row type="flex" justify="end">
            <a-menu class="header-menu-btns" mode="horizontal">
              <nuxt-link v-if="!isAuthenticated" to="/login"><a-button icon="unlock">Login</a-button></nuxt-link>&nbsp;
              <nuxt-link v-if="!isAuthenticated" to="/register"><a-button icon="lock">Register</a-button></nuxt-link>

              <nuxt-link v-if="isAuthenticated" to="/backend/admin/dashboard"><a-button icon="home">Dashboard</a-button></nuxt-link>
            </a-menu>
          </a-row>
        </a-col>
      </a-row>
    </div>
  </a-layout-header>
</template>

<script>
  export default {
    data() {
      return {
        current: ['home'],
        isAuthenticated: false
      }
    },

    mounted() {
      this.isAuthenticated = !!this.$apolloHelpers.getToken();
    }
  }
</script>

<style scoped>
  .ant-layout-header {
    background: #ffffff;
  }

  .content-sidebar-wrapper {
    background: #f0f2f5;
  }

  .header-menu-right {
    border: none;
    margin-top: 16px;
  }

  .header-menu-btns {
    border: none;
    margin-top: 16px;
  }
</style>
