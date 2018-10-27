defmodule ApiWeb.JobApplicationController do
  use ApiWeb, :controller

  alias Api.JobApplications
  # alias Api.JobApplications.JobApplication

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    job_applications = JobApplications.list_job_applications()
    render(conn, "index.json", job_applications: job_applications)
  end

#  def create(conn, %{"job_application" => job_application_params}) do
#    with {:ok, %JobApplication{} = job_application} <- JobApplications.create_job_application(job_application_params) do
#      conn
#      |> put_status(:created)
#      |> put_resp_header("location", job_application_path(conn, :show, job_application))
#      |> render("show.json", job_application: job_application)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    job_application = JobApplications.get_job_application!(id)
#    render(conn, "show.json", job_application: job_application)
#  end
#
#  def update(conn, %{"id" => id, "job_application" => job_application_params}) do
#    job_application = JobApplications.get_job_application!(id)
#
#    with {:ok, %JobApplication{} = job_application} <- JobApplications.update_job_application(job_application, job_application_params) do
#      render(conn, "show.json", job_application: job_application)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    job_application = JobApplications.get_job_application!(id)
#    with {:ok, %JobApplication{}} <- JobApplications.delete_job_application(job_application) do
#      send_resp(conn, :no_content, "")
#    end
#  end
end
