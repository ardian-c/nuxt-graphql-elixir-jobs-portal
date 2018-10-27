defmodule Api.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :path, :string
      add :size, :integer
      add :file_type, :string
      add :type, :string

      timestamps()
    end

  end
end
