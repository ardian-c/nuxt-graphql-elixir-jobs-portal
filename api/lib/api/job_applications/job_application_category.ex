defmodule Api.JobApplications.JobApplicationCategory do

  use Ecto.Schema
  import Ecto.Changeset

  schema "job_application_categories" do
    field :job_application_id, :integer
    field :category_id, :integer
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:job_application_id, :category_id])
    |> validate_required([:job_application_id, :category_id])
  end
end