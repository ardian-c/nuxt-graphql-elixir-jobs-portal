defmodule Api.Repo.Migrations.CreateJobSeekers do
  use Ecto.Migration

  def change do
    create table(:job_seekers) do
      add :profession, :string
      add :description, :string

      timestamps()
    end

  end
end
