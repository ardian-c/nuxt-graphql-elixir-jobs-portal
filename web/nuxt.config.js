module.exports = {
  /*
  ** Headers of the page
  */
  head: {
    title: 'web',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ],
  },

  css: [
    'ant-design-vue/dist/antd.css',
    'quill/dist/quill.snow.css',
    'quill/dist/quill.bubble.css',
    'quill/dist/quill.core.css',
    '~/assets/css/main.css'
  ],

  modules: [
    '@nuxtjs/axios',
    '@nuxtjs/auth',
    '@nuxtjs/apollo',
    '@nuxtjs/dotenv',
  ],

  axios: {},

  apollo: {
    clientConfigs: {
      default: {
        httpEndpoint: process.env.HTTP_ENDPOINT || 'http://localhost:4000/api/v1/graphql'
      }
    }
  },

  /*
  ** Customize the progress bar color
  */
  loading: { color: '#3B8070' },
  /*
  ** Build configuration
  */
  build: {
    /*
    ** Run ESLint on save
    */
    extend (config, { isDev, isClient }) {
      if (isDev && isClient) {
        config.module.rules.push({
          enforce: 'pre',
          test: /\.(js|vue)$/,
          loader: 'eslint-loader',
          exclude: /(node_modules)/
        });
      }
    },
    vendor: ['vue-infinite-scroll', 'vue-virtual-scroller']
  },
  plugins: [
    { src: '~/plugins/vue-infinite-scroll', ssr: false },
    { src: '~/plugins/vue-virtual-scroller', ssr: false },
    { src: '~/plugins/nuxt-quill-plugin.js', ssr: false },
    { src: '~/plugins/eventBus.js'}
  ]
}

