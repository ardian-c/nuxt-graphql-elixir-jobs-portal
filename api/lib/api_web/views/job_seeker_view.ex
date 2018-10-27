defmodule ApiWeb.JobSeekerView do
  use ApiWeb, :view
  alias ApiWeb.JobSeekerView

  def render("index.json", %{job_seekers: job_seekers}) do
    %{data: render_many(job_seekers, JobSeekerView, "job_seeker.json")}
  end

  def render("show.json", %{job_seeker: job_seeker}) do
    %{data: render_one(job_seeker, JobSeekerView, "job_seeker.json")}
  end

  def render("job_seeker.json", %{job_seeker: job_seeker}) do
    %{id: job_seeker.id,
      profession: job_seeker.profession,
      description: job_seeker.description}
  end
end
