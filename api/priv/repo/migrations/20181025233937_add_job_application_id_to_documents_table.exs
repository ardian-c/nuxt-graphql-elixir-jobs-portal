defmodule Api.Repo.Migrations.AddJobApplicationIdToDocumentsTable do
  use Ecto.Migration

  def up do
    # execute "ALTER TABLE documents DROP CONSTRAINT documents_job_application_id_fkey"
    alter table(:documents) do
      add :job_application_id, references(:job_applications, on_delete: :delete_all)
    end

    create index(:documents, [:job_application_id])
  end

  def down do
    # execute "ALTER TABLE documents DROP CONSTRAINT documents_job_application_id_fkey"
    # drop index(:documents, [:job_application_id])
  end
end
