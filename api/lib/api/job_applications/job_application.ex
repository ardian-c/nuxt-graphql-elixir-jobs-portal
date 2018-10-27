defmodule Api.JobApplications.JobApplication do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job_applications" do
    field :address, :string
    field :content, :string
    field :priority, :integer
    field :slug, :string
    field :source, :string
    field :status, :integer
    field :title, :string
    field :published_at, :utc_datetime
    field :published_timezone, :string, default: "UTC"
    field :ends_at, :utc_datetime

    timestamps()

    belongs_to :company, Api.Companies.Company
    many_to_many :categories, Api.Categories.Category, join_through: "job_application_categories"
    has_many :documents, Api.Documents.Document
  end

  @doc false
  def changeset(job_application, attrs) do
    job_application
    |> cast(attrs, [:title, :content, :slug, :address, :status, :priority, :source])
    |> validate_required([:title, :content, :slug, :address, :status, :priority, :source])
  end
end
