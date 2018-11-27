defmodule Api.Repo.Migrations.CreateJobApplicationCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:job_application_categories) do
      add :job_application_id, references(:job_applications, column: "id", type: :id)
      add :category_id, references(:categories, column: "id", type: :id)
    end

    create index(:job_application_categories, [:job_application_id, :category_id], unique: true)
  end
end
