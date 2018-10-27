defmodule Api.JobSeekers.JobSeeker do
  use Ecto.Schema
  import Ecto.Changeset


  schema "job_seekers" do
    field :description, :string
    field :profession, :string

    timestamps()

  end

  @doc false
  def changeset(job_seeker, attrs) do
    job_seeker
    |> cast(attrs, [:profession, :description])
    |> validate_required([:profession, :description])
  end
end
