defmodule Api.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :description, :string
    field :name, :string

    timestamps()

    many_to_many :job_applications, Api.JobApplications.JobApplication, join_through: "job_application_categories"
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
