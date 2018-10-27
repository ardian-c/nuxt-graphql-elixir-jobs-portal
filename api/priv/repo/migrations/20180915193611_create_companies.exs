defmodule Api.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :users_id, references(:users)
      add :name, :string
      add :address, :string, null: true
      add :email, :string
      add :phone, :string, null: true
      add :logo, :string, null: true

      timestamps()
    end

    create unique_index(:companies, [:name])
    create unique_index(:companies, [:email])
  end
end
