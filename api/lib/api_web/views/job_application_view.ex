defmodule ApiWeb.JobApplicationView do
  use ApiWeb, :view
  alias ApiWeb.JobApplicationView

  def render("index.json", %{job_applications: job_applications}) do
    %{data: render_many(job_applications, JobApplicationView, "job_application.json")}
  end

  def render("show.json", %{job_application: job_application}) do
    %{data: render_one(job_application, JobApplicationView, "job_application.json")}
  end

  def render("job_application.json", %{job_application: job_application}) do
    %{id: job_application.id,
      title: job_application.title,
      content: job_application.content,
      slug: job_application.slug,
      address: job_application.address,
      status: job_application.status,
      priority: job_application.priority,
      source: job_application.source}
  end
end
