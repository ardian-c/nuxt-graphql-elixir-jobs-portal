defmodule Api.Cities.City do
  use Ecto.Schema
  import Ecto.Changeset


  schema "cities" do
    field :name, :string
    field :description, :string

    timestamps()

    has_many :job_applications, Api.JobApplications.JobApplication
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
