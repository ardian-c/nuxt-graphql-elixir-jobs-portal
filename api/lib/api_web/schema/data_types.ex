defmodule ApiWeb.Schema.DataTypes do

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  alias Api.Companies
  alias Api.Categories
  alias Api.Documents

  # user
  @desc "User register data"
  input_object :user_register do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
    field :password_confirmation, :string
  end

  @desc "User data"
  object :user do
    field :id, :id
    field :email, :string
    field :is_admin, :string
    field :inserted_at, :string
    field :updated_at, :string
  end

  # company
  @desc "Company register data"
  input_object :company_data do
    field :id, :id
    field :name, :string
    field :address, :string
    field :email, :string
    field :phone, :string
  end

  @desc "Company data"
  object :company do
    field :id, :id
    field :name, :string
    field :address, :string
    field :email, :string
    field :phone, :string
    field :logo, :company_logo
    field :inserted_at, :string
    field :updated_at, :string
  end

  @desc "Company Logo"
  object :company_logo do
    field :file_name, :string
    field :updated_at, :string
  end

  # category
  @desc "Category data"
  object :category do
    field :id, :id
    field :name, :string
    field :description, :string
    field :inserted_at, :string
    field :updated_at, :string
  end

  object :category_with_posts do
    field :count_posts, :string
    field :id, :id
    field :name, :string
  end

  @desc "Company register data"
  input_object :category_data do
    field :name, :string
    field :description, :string
  end

  @desc "Job application preview"
  object :job_application_preview do
    field :id, :id
    field :title, :string
    field :content, :string
    field :slug, :string
    field :address, :string
    field :status, :integer
    field :priority, :integer
    field :source, :string
    field :ends_at, :string
    field :published_at, :string
    field :published_timezone, :string
    field :company, :company, resolve: dataloader(Companies)
  end

  # job application
  @desc "Job application"
  object :job_application do
    field :id, :id
    field :title, :string
    field :content, :string
    field :slug, :string
    field :address, :string
    field :status, :integer
    field :priority, :integer
    field :source, :string
    field :ends_at, :string
    field :published_at, :string
    field :published_timezone, :string
    field :company, :company, resolve: dataloader(Companies)
    field :categories, list_of(:category), resolve: dataloader(Categories)
    field :documents, list_of(:document), resolve: dataloader(Documents)
  end

  input_object :job_application_data do
    field :title, :string
    field :slug, :string
    field :content, :string
    field :address, :string
    field :status, :integer
    field :priority, :integer
    field :source, :string
    field :ends_at, :string
    field :published_at, :string
    field :company_id, :string, default_value: ""
    field :categories, list_of(:string)
    field :is_scheduled, :boolean
  end

  # documents
  object :document do
    field :id, :id
    field :path, :string
    field :size, :string
    field :file_type, :string
    field :type, :string
    field :inserted_at, :string
    field :updated_at, :string
  end

  # misc
  @desc "Session data"
  object :session do
    field :token, :string
    field :user, :user
  end

  @desc "Generic response message"
  object :generic_response do
    field :code, :integer
    field :message, :string
  end
end
