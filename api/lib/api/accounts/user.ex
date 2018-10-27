defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
#  import Ecto.Query, only: [from: 2]

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

#  @default_preloads [
#    documents: from(d in Api.Documents.Document, order_by: [asc: d.id])
#  ]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password_hash, :string
    field :is_admin, :boolean, default: false
    # virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    # has_many :documents, Api.Documents.Document

    timestamps()
  end

  @doc false
  def changeset(%Api.Accounts.User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :password_confirmation])
    |> validate_required([:first_name, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
