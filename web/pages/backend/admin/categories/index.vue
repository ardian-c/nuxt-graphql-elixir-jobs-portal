<template>
<div class="job-applications-wrapper">
  <a-layout-header style="background: #fff; padding: 0" />
    <a-layout-content style="margin: 0 16px">
      <a-breadcrumb style="margin: 16px 0">
        <a-breadcrumb-item>Home</a-breadcrumb-item>
        <a-breadcrumb-item>Categories</a-breadcrumb-item>
      </a-breadcrumb>

      <div :style="{ padding: '24px', background: '#fff', minHeight: '360px' }">
				<a-row>
            <a-col :span="8">
              <a-button type="primary" class="editable-add-btn" @click="handleAddNewCategory">Add New Category</a-button>
            </a-col>
            <a-col :span="8" :offset="8">
              <a-input-search 
                placeholder="input search text"
                style="width: 200px"
                @search="onSearch"
              />
            </a-col>
          </a-row><br />

          <a-table 
	          :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}" 
	          :dataSource="categories" 
	          :pagination="pagination" 
	          :columns="columns" 
	          :loading="loading" 
	          @change="handleTableChange"
          >
            <span slot="action" slot-scope="text, record">
              <nuxt-link :to="{ path: `/backend/admin/categories/${record.id}`}">View</nuxt-link>
              <a-divider type="vertical" />
              <a-popconfirm
                v-if="categories.length"
                title="Are you sure you want to delete this category?"
                @confirm="() => onDelete(record.key)">
                <a href="javascript:;">Delete</a>
              </a-popconfirm>
            </span>

            <div slot="filterDropdown" slot-scope="{ setSelectedKeys, selectedKeys, confirm, clearFilters }" class='custom-filter-dropdown'>
              <a-input
                ref="searchInput"
                placeholder='Search name'
                :value="selectedKeys[0]"
                @change="e => setSelectedKeys(e.target.value ? [e.target.value] : [])"
                @pressEnter="() => handleSearch(selectedKeys, confirm)"
              />
              <a-button type='primary' @click="() => handleSearch(selectedKeys, confirm)">Search</a-button>
              <a-button @click="() => handleReset(clearFilters)">Reset</a-button>
            </div>
            <a-icon slot="filterIcon" slot-scope="filtered" type='smile-o' :style="{ color: filtered ? '#108ee9' : '#aaa' }" />
            <template slot="customRender" slot-scope="text">
              <span v-if="searchText">
                <template v-for="(fragment, i) in text.split(new RegExp(`(?<=${searchText})|(?=${searchText})`, 'i'))">
                  <span v-if="fragment.toLowerCase() === searchText.toLowerCase()" :key="i" class="highlight">{{fragment}}</span>
                  <template v-else>{{fragment}}</template>
                </template>
              </span>
              <template v-else>{{text}}</template>
            </template>
          </a-table>
      </div>
  </a-layout-content>
</div>
</template>

<script>

import allCategoriesQuery from '~/apollo/queries/allCategories.gql';

const categories = [];

export default {
	layout: 'backend',

	head() {
		return {
			title: 'Categories',
			meta: [
			{ hid: 'categories', name: 'categories', content: 'Backend | Categories'}
			]
		}
	},

	apollo: {
		allCategories: {
      prefetch: true,
      query:  allCategoriesQuery,
      variables: {
        offset: this.offset,
        keyword: ''
      },
      result({data}){
        const pagination = { ...this.pagination };
        this.loading = true;
        this.categories = data.allCategories;
        pagination.total = data.countCategories;
        pagination.pageSize = this.perPage;
        this.pagination = pagination;
        this.loading = false;
      }
    }
	},

	data() {
		return {
			categories: [],
			perPage: 25,
			offset: 0,
			pagination: {},
			loading: false,
			selectedRowKeys: [],
			searchText: '',
			keyword: '',
			columns: [{
			title: 'Name',
			dataIndex: 'name',
			key: 'name',
			scopedSlots: {
			  filterDropdown: 'filterDropdown',
			  filterIcon: 'filterIcon',
			  customRender: 'customRender',
			},
			onFilter: (value, record) => record.name.toLowerCase().includes(value.toLowerCase()),
			onFilterDropdownVisibleChange: (visible) => {
			  if (visible) {
			    setTimeout(() => {
			      this.$refs.searchInput.focus()
			    })
			  }
			},
			}, {
			title: 'Description',
			dataIndex: 'description',
			key: 'description',
			}, {
			title: 'Action',
			key: 'action',
			scopedSlots: { customRender: 'action' },
			}],
		}
	},

	computed: {
    hasSelected() {
      return this.selectedRowKeys.length > 0
    }
  },

  methods: {
  	async fetch(currentPage) {
      this.loading = true;
      
      let offset = (this.pagination.current !== 'undefined' && this.pagination.current == 1) ? 0 : ((this.pagination.pageSize * currentPage) - this.pagination.pageSize);
      let keyword = this.keyword;

      const apolloClient = this.$apollo.provider.defaultClient;

      const res = await apolloClient.query({
        query: allCategoriesQuery,
        variables: {
          offset,
          keyword
        }
      }).then(({data}) => {
        this.loading = false;
        this.categories = data.allCategories;
        const pagination = { ...this.pagination };
        pagination.total = data.countCategories;
        this.pagination = pagination;
        return data
      }).catch((err) => {
        this.loading = false;
        console.log("err: ", err);
      });
    },

  	async onSearch(keyword) {
      this.keyword = keyword;

      const apolloClient = this.$apollo.provider.defaultClient;
      const offset = 0;

      await apolloClient.query({
        query: allCategoriesQuery,
        variables: {
          offset,
          keyword
        }
      }).then(({data}) => {
        this.loading = false;
        this.categories = data.allCategories;
        const pagination = { ...this.pagination };
        pagination.total = data.countCategories;
        this.pagination = pagination;
        return data
      }).catch((err) => {
        this.loading = false;
        console.log("err: ", err);
      });
    },

  	handleAddNewCategory() {
  		this.$router.push({ path: 'categories/create' });
  	},

  	onDelete (key) {
      const dataSource = [...this.categories]
      this.dataSource = dataSource.filter(item => item.key !== key)
    },

    handleTableChange (pagination, filters, sorter) {
      const pager = { ...this.pagination };
      pager.current = pagination.current;
      this.pagination = pager;
      this.fetch(pagination.current);
    },

  	handleSearch (selectedKeys, confirm) {
      confirm()
      this.searchText = selectedKeys[0]
    },

    handleReset (clearFilters) {
      clearFilters()
      this.searchText = ''
    },

    onSelectChange (selectedRowKeys) {
      console.log('selectedRowKeys changed: ', selectedRowKeys);
      this.selectedRowKeys = selectedRowKeys
    }
  }
}
</script>

<style>
	
</style>