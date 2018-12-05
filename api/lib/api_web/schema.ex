defmodule ApiWeb.Schema do

  use Absinthe.Schema
  alias Api.Repo
  alias ApiWeb.Resolvers

  import_types Absinthe.Plug.Types
  import_types Absinthe.Type.Custom
  import_types __MODULE__.DataTypes

  #
  # QUERIES
  #
  query do
    # users
    @desc "Get a user"
    field :user, type: :user do
      arg :id, non_null(:id)

      resolve &Resolvers.Accounts.get_by_id/3
    end

    # companies
    @desc "Get all companies"
    field :all_companies, list_of(:company) do
      arg :offset, :integer, default_value: 0
      arg :keyword, :string, default_value: nil

      resolve &Resolvers.Companies.get_all_companies/3
    end

    @desc "Get all companies - no pagination"
    field :all_companies_no_pagination, list_of(:company) do

      resolve &Resolvers.Companies.get_all_companies_no_pagination/3
    end

    @desc "Count of all companies"
    field :count_companies, :integer do
      resolve(fn args, _ ->
        count_companies =
          Api.Companies.Company
          |> Repo.count()

        {:ok, count_companies}
      end)
    end

    @desc "Get a company"
    field :single_company, type: :company do
      arg :id, non_null(:id)

      resolve &Resolvers.Companies.get_by_id/3
    end

    # categories
    @desc "Get all categories"
    field :all_categories, list_of(:category) do
      arg :offset, :integer, default_value: 0
      arg :keyword, :string, default_value: nil

      resolve &Resolvers.Categories.get_all_categories/3
    end

    @desc "Get all categories - no pagination"
    field :all_categories_no_pagination, list_of(:category) do
      resolve &Resolvers.Categories.get_all_categories_no_pagination/3
    end

    @desc "Get all categories - order by most posts"
    field :all_categories_order_by_posts, list_of(:category_with_posts) do
      resolve &Resolvers.Categories.get_all_categories_order_by_posts/3
    end

    @desdc "Get all categories, search name or description"
    field :single_category_by_name_or_description, list_of(:category) do
      arg :keyword, non_null(:string)

      resolve &Resolvers.Categories.get_by_name_or_description/3
    end

    @desc "Count of all categories"
    field :count_categories, :integer do
      resolve(fn args, _ ->
        count_categories =
          Api.Categories.Category
          |> Repo.count()

        {:ok, count_categories}
      end)
    end

    @desc "Get a category"
    field :single_category, type: :category do
      arg :id, non_null(:id)

      resolve &Resolvers.Categories.get_by_id/3
    end

    # cities
    @desc "Get all cities"
    field :all_cities_no_pagination, list_of(:city) do
      resolve &Resolvers.Cities.get_all_cities_no_pagination/3
    end

    @desc "Get all cities - order by posts"
    field :all_cities_order_by_posts, list_of(:city_with_posts) do
      resolve &Resolvers.Cities.get_all_cities_order_by_posts/3
    end

    # job applications
    @desc "Get all job applications"
    field :all_job_applications, list_of(:job_application) do
      arg :offset, :integer, default_value: 0
      arg :keyword, :string, default_value: nil
      arg :time, :string, default_value: nil
      arg :jcat, :integer, default_value: nil
      arg :jcity, :integer, default_value: nil

      resolve &Resolvers.JobApplications.get_all_job_applications/3
    end

#    @desc "Get all job applications with filters"
#    field :get_all_job_applications_filtered, list_of(:job_application) do
#      arg :offset, :integer, default_value: 0
#      arg :keyword, :string, default_value: nil
#      arg :time, :string, default_value: nil
#      arg :category, :integer, default_value: nil
#      arg :city, :integer, default_value: nil
#
#      resolve &Resolvers.JobApplications.get_all_job_applications_filtered/3
#    end

    @desc "Get single job application"
    field :single_job_application, :job_application do
      arg :id, non_null(:id)

      resolve &Resolvers.JobApplications.get_by_id/3
    end

    @desc "Get single job application"
    field :single_job_application_by_slug, :job_application do
      arg :slug, non_null(:string)

      resolve &Resolvers.JobApplications.get_by_slug_new/3
    end

    @desc "Count of all job applications"
    field :count_job_applications, :integer do
      resolve(fn args, _ ->
        count_job_applications =
          Api.JobApplications.JobApplication
          |> Repo.count()

        {:ok, count_job_applications}
      end)
    end
  end

  #
  # MUTATIONS
  #
  mutation do
    # user
    @desc "Login a user"
    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.Accounts.login/3
    end

    @desc "Register a user"
    field :register, :session do
      arg :input, non_null(:user_register)

      resolve &Resolvers.Accounts.register/3
    end

    # category
    @desc "Category create"
    field :new_category, :category do
      arg :input, non_null(:category_data)

      resolve &Resolvers.Categories.add_category/3
    end

    @desc "Category delete"
    field :delete_category, :generic_response do
      arg :category_id, non_null(:id)

      resolve &Resolvers.Categories.delete_category/3
    end

    # company
    @desc "Company create"
    field :new_company, :company do
      arg :input, non_null(:company_data)

      resolve &Resolvers.Companies.add_company/3
    end

    @desc "Company add logo"
    field :upload_company_logo, :company do
      arg :logo, non_null(:upload)
      arg :company_id, non_null(:id)

      resolve &Resolvers.Companies.add_company_logo/3
    end

    @desc "Company delete"
    field :delete_company, :generic_response do
      arg :company_id, non_null(:id)

      resolve &Resolvers.Companies.delete_company/3
    end

    # job application
    @desc "New job application"
    field :new_job_application, :job_application do
      arg :input, non_null(:job_application_data)
      arg :documents, list_of(:upload)

      resolve &Resolvers.JobApplications.add_new_job_application/3
    end

    @desc "Delete job application"
    field :delete_job_application, :generic_response do
      arg :job_application_id, non_null(:id)

      resolve &Resolvers.JobApplications.delete_job_application/3
    end
  end

  #
  # OTHER
  #
  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader() do
    alias Api.Companies
    alias Api.Categories

    Dataloader.new()
    |> Dataloader.add_source(Companies, Companies.data())
    |> Dataloader.add_source(Categories, Categories.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end
end
