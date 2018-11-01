defmodule ApiWeb.Resolvers.JobApplications do

  require Logger

  alias Api.Repo
  alias Api.JobApplications
  alias Api.JobApplications.JobApplication
  alias Api.JobApplications.JobApplicationCategory

  alias Api.DocumentUploader
  alias Api.Documents.Document

  @doc """
    Get all job applications
  """
  def get_all_job_applications(_, %{ keyword: keyword, offset: offset }, _) do
    job_applications = JobApplication
        |> JobApplications.search(keyword)
        |> Repo.paginate(offset)
        |> Repo.all()
    {:ok, job_applications}
  end


  @doc """
    Add new job application
  """
  def add_new_job_application(_, %{ input: params, documents: documents }, _) do
    with {:ok, %JobApplication{} = job_application} <- JobApplications.create_job_application(params) do
      # add relation with company & company
      for category <- params.categories do
        Repo.insert!(JobApplicationCategory.changeset(%JobApplicationCategory{}, %{ job_application_id: job_application.id, category_id: category }))
      end

      # insert documents related to job application (if any)
      for document <- documents do
        {:ok, document_path } = DocumentUploader.store({document, job_application})

        Repo.insert!(Document.changeset(%Document{}, %{file_type: document.content_type, path: document_path, job_application_id: job_application.id}))
      end
      # add documents
      {:ok, job_application}
    end
  end
end
