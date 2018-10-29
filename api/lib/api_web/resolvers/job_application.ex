defmodule ApiWeb.Resolvers.JobApplications do

  require Logger

  alias Api.Repo
  alias Api.JobApplications
  alias Api.JobApplications.JobApplication

  @desc "Add new job application"
  def add_new_job_application(_, %{ input: params, documents: documents }, _) do
#    slug = params[:slug] <> "-" <> Enum.random(1..1_000000)
#    Map.put(params, :slug, slug)
    Logger.info "params: #{inspect(params)}"
    with {:ok, %JobApplication{} = job_application} <- JobApplications.create_job_application(params) do
      # add relation with company

      # add relation with categories

      # add documents
      {:ok, job_application}
    end
  end
end
