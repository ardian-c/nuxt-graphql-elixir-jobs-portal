defmodule Api.Repo.Migrations.CreateJobApplicationCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:job_application_categories) do
      add :job_application_id, references(:job_applications)
      add :category_id, references(:categories)
    end

    create index(:job_application_categories, [:job_application_id, :category_id], unique: true)
  end
end
