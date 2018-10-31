defmodule Api.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "documents" do
    field :file_type, :string
    field :path, :string
    field :size, :integer
    field :type, :string

    field :job_application_id, :integer

    timestamps()

    belongs_to :job_applications, Api.JobApplications.JobApplication
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:path, :size, :file_type, :type, :job_application_id ])
    |> validate_required([:path, :file_type])
  end
end
