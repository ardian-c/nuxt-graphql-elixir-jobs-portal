<template>
  <section class="main-wrapper f-wrapper">
    <navbar></navbar>
    <div class="main-content">
      <nuxt/>
    </div>
    <main-footer></main-footer>
  </section>
</template>

<script>
  import Vue from 'vue'
  import Antd from 'ant-design-vue'

  import MainFooter from '~/components/homepage/mainfooter';
  import Navbar from '~/components/homepage/navbar';

  Vue.use(Antd)

  export default {
    components: {
      Navbar,
      MainFooter
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

.single-job-container {
  min-height: 650px;
}

.job-content {
  margin: 30px 0;
  height: auto;
  min-height: 1000px;
}
</style>

