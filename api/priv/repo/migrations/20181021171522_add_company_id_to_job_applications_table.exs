defmodule Api.Repo.Migrations.AddCompanyIdToJobApplicationsTable do
  use Ecto.Migration

  def up do
    # execute "ALTER TABLE job_applications DROP CONSTRAINT job_applications_company_id_fkey"
    alter table(:job_applications) do
      add :company_id, references(:companies, on_delete: :nilify_all)
    end

    create index(:job_applications, [:company_id])
  end

  def down do
    #execute "ALTER TABLE documents DROP CONSTRAINT documents_job_application_id_fkey"
    # drop index(:job_applications, [:company_id])
  end
end
