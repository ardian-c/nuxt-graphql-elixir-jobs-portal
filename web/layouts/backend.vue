<template>
  <a-layout id="backend-layout" style="min-height: 100vh">
    <a-layout-sider
      collapsible
      v-model="collapsed"
    >
      <div class="logo"></div>
      <a-menu theme="dark" :selectedKeys="selectedRoute" mode="inline">
        <a-menu-item key="1">
          <a-icon type="pie-chart" />
          <span>Dashboard</span>
        </a-menu-item>

        <a-menu-item key="2">
          <nuxt-link to="/backend/admin/job-applications"><a-icon type="desktop" />
          <span>Job Applications</span>
          </nuxt-link>
        </a-menu-item>

        <a-menu-item key="3">
          <nuxt-link to="/backend/admin/categories"><a-icon type="tags" />
          <span>Categories</span>
          </nuxt-link>
        </a-menu-item>

        <a-menu-item key="4">
          <nuxt-link to="/backend/admin/companies"><a-icon type="api" />
          <span>Companies</span>
          </nuxt-link>
        </a-menu-item>

        <a-sub-menu
          key="sub1"
        >
          <span slot="title"><a-icon type="user" /><span>User</span></span>
          <a-menu-item key="5">All</a-menu-item>
          <a-menu-item key="6">Add User</a-menu-item>
        </a-sub-menu>

        <a-menu-item key="6">
          <a-icon type="setting" />
          <span>Settings</span>
        </a-menu-item>

        <a-menu-item key="7" @click="onLogout">
          <a-icon type="logout"/>
          <span>Logout</span>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>
    <a-layout>
      <nuxt />
      <a-layout-footer style="text-align: center">
        N'punë ©2018
      </a-layout-footer>
    </a-layout>
  </a-layout>
</template>

<script>

import Vue from 'vue'
import Antd from 'ant-design-vue'

Vue.use(Antd)

export default {
  middleware: 'authenticated',

  data(){
    return {
      selectedRoute: [],
      collapsed: false,
    }
  },

  watch: {
    $route () {
      switch(this.$route.path) {
        case '/backend/admin/job-applications':
          this.selectedRoute = ['2'];
          break;

        case '/backend/admin/categories':
          this.selectedRoute = ['3'];
          break;

        case '/backend/admin/companies':
          this.selectedRoute = ['4'];
          break;

        default:
            this.selectedRoute = ['1'];
      }
    }
  },

  mounted() {
    switch($nuxt.$route.path) {
      case '/backend/admin/job-applications':
        this.selectedRoute = ['2'];
        break;

      case '/backend/admin/categories':
        this.selectedRoute = ['3'];
        break;

      case '/backend/admin/companies':
        this.selectedRoute = ['4'];
        break;

      default:
          this.selectedRoute = ['1'];
    }
  },

  methods: {
    async onLogout(){
      await this.$apolloHelpers.onLogout()
      setTimeout(() => {
        this.$router.push('/login');
      }, 1000);
    }
  }
}
</script>

<style>
html {
  font-family: "Source Sans Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  font-size: 16px;
  word-spacing: 1px;
  -ms-text-size-adjust: 100%;
  -webkit-text-size-adjust: 100%;
  -moz-osx-font-smoothing: grayscale;
  -webkit-font-smoothing: antialiased;
  box-sizing: border-box;
}

*, *:before, *:after {
  box-sizing: border-box;
  margin: 0;
}

#backend-layout .logo {
  height: 32px;
  background: rgba(255,255,255,.2);
  margin: 16px;
}

#backend-layout .ant-layout-sider-trigger {
  width: 200px;
}

#backend-layout .ant-layout-sider-collapsed .ant-layout-sider-trigger {
  width: 80px;
}
</style>

