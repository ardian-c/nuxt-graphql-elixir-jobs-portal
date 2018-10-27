defmodule ApiWeb.JobSeekerController do
  use ApiWeb, :controller

  alias Api.JobSeekers
  # alias Api.JobSeekers.JobSeeker

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    job_seekers = JobSeekers.list_job_seekers()
    render(conn, "index.json", job_seekers: job_seekers)
  end

#  def create(conn, %{"job_seeker" => job_seeker_params}) do
#    with {:ok, %JobSeeker{} = job_seeker} <- JobSeekers.create_job_seeker(job_seeker_params) do
#      conn
#      |> put_status(:created)
#      |> put_resp_header("location", job_seeker_path(conn, :show, job_seeker))
#      |> render("show.json", job_seeker: job_seeker)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    job_seeker = JobSeekers.get_job_seeker!(id)
#    render(conn, "show.json", job_seeker: job_seeker)
#  end
#
#  def update(conn, %{"id" => id, "job_seeker" => job_seeker_params}) do
#    job_seeker = JobSeekers.get_job_seeker!(id)
#
#    with {:ok, %JobSeeker{} = job_seeker} <- JobSeekers.update_job_seeker(job_seeker, job_seeker_params) do
#      render(conn, "show.json", job_seeker: job_seeker)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    job_seeker = JobSeekers.get_job_seeker!(id)
#    with {:ok, %JobSeeker{}} <- JobSeekers.delete_job_seeker(job_seeker) do
#      send_resp(conn, :no_content, "")
#    end
#  end
end
