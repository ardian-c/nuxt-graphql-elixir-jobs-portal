defmodule Api.Repo.Migrations.AddCityIdToJobApplicationsTable do
  use Ecto.Migration

  def up do

    alter table(:job_applications) do
      add :city_id, references(:cities, on_delete: :nilify_all)
    end

    create index(:job_applications, [:city_id])
  end

  def down do
    #execute "ALTER TABLE documents DROP CONSTRAINT documents_job_application_id_fkey"
    # drop index(:job_applications, [:city_id])
  end
end
