defmodule Api.Companies.Company do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  schema "companies" do
    field :address, :string
    field :email, :string
    field :name, :string
    field :phone, :string
    field :logo, Api.CompanyLogoUploader.Type

    timestamps()

    belongs_to :users, Api.Accounts.User
    has_many :job_applications, Api.JobApplications.JobApplication
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :address, :email, :phone])
    |> cast_attachments(attrs, [:logo])
    |> validate_required([:name, :address, :email])
    |> unique_constraint(:name)
    |> unique_constraint(:email)
  end
end
