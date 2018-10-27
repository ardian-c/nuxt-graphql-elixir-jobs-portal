defmodule Api.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string, null: true
      add :email, :string
      add :password_hash, :string
      add :is_admin, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
