defmodule Api.Repo.Migrations.CreateJobApplications do
  use Ecto.Migration

  def change do
    create table(:job_applications) do
      add :title, :string
      add :content, :text
      add :slug, :string
      add :address, :string
      add :status, :integer
      add :priority, :integer
      add :source, :string
      add :published_at, :utc_datetime
      add :published_timezone, :string, default: "UTC"
      add :ends_at, :utc_datetime

      # add :company_id, references(:companies)
      # add :category_id, references(:categories)

      timestamps()
    end

  end
end
