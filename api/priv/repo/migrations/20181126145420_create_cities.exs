defmodule Api.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
