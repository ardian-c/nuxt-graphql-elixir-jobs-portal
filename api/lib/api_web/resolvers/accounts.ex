defmodule ApiWeb.Resolvers.Accounts do

  alias Api.Repo
  alias Api.Guardian
  alias Api.Accounts
  alias Api.Accounts.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @desc "Register user"
  def register(_, %{ input: params }, _) do
    with {:ok, %User{} = user} <- Accounts.create_user(params),
      {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      # %{jwt: token, user: user}
      res = %{token: token, user: user}
      {:ok, res}
    end
  end

  @desc "Get user by id"
  def get_by_id(_, %{ id: id}, _) do
    case Repo.get_by!(User, id: id) do
      user ->
        {:ok, user}
      nil ->
        {:error, "Something went wrong, no such user"}
    end
  end

  @desc "Login user"
  def login(_, %{ email: email, password: password }, _) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        res = %{user: user, token: token}
        {:ok, res}
      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with { :ok, user } <- get_by_email(email),
    do: verify_password(password, user)
  end

  defp get_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        dummy_checkpw()
        {:error, "Something went wrong, can't log you in."}
      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
