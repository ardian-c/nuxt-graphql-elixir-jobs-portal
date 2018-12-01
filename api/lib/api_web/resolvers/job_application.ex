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
  def get_all_job_applications(_, params , _) do
    job_applications = JobApplication
       |> JobApplications.search(params[:keyword], params[:jcat], params[:jcity])
       |> Repo.paginate(params[:offset])
       |> Repo.all()
   {:ok, job_applications}
  end

  @doc """
    Get all applications filtered
  """
  def get_all_job_applications_filtered(_, %{
    offset: offset,
    keyword: keyword,
    time: time,
    category: category,
    city: city
  }, _) do
    job_applications = JobApplication
      |> JobApplications.search(keyword)
      |> Repo.paginate(50)
      |> Repo.all()
    {:ok, job_applications}
  end

  @doc """
    Get a single job application
  """
  def get_by_slug(_, %{ slug: slug }, _) do
    case Repo.get_by!(JobApplication, slug: slug) do
      job_application ->
        {:ok, job_application}
      nil ->
        {:error, "Something went wrong, no such job application"}
    end
  end

  @doc """
    Get a single job application
  """
  def get_by_id(_, %{ id: id }, _) do
    case Repo.get_by!(JobApplication, id: id) do
      job_application ->
        {:ok, job_application}
      nil ->
        {:error, "Something went wrong, no such job application"}
    end
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

  @doc """
    Delete a job application
  """
  def delete_job_application(_, %{ job_application_id: job_application_id }, _) do
    job_application = JobApplication
              |> Repo.get!(job_application_id)

    Repo.delete_all(JobApplicationCategory)

    if job_application |> JobApplications.delete_job_application() do
      res = %{code: 200, message: 'Job application deleted successfully!'}
      {:ok, res }
    else
      res = %{code: 401, message: 'Something went wrong!'}
      {:error, res }
    end
  end
end
