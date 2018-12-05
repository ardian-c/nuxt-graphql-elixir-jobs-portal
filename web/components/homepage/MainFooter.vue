<template>
  <div id="main-footer">
      <div class="container">
        <a-row>
          <a-col :span="6" class="f-item">
            <h4>Address</h4>
            <p>Prishtine, 10000</p>
          </a-col>

          <a-col :span="6" class="f-item">
            <h4>Phone</h4>
            <p>+38344182189</p>
          </a-col>

          <a-col :span="6" class="f-item">
            <h4>Email</h4>
            <p>info@npune.com</p>
          </a-col>

          <a-col :span="6" class="f-item">
            <h4>Info</h4>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Accusamus alias consequatur delectus dolores facere inventore.</p>
          </a-col>
        </a-row>
      </div>
  </div>
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

<style>
#main-footer {
  min-height: 200px;
  background:#183172;
}
.f-item {
  padding: 20px 0;
  color: #f5f5f5;
}
.f-item h4 {
  color: #f5f5f5;
}
</style>
