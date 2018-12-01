defmodule Api.Repo do
  use Ecto.Repo, otp_app: :api
  import Ecto.Query, warn: false

  @per_page 25

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def count(query) do
    one(from(r in query, select: count("*")))
  end

  def paginate(query, offset) do
    from(r in query, offset: ^offset, limit: @per_page)
  end

  def fetch(query) do
    case all(query) do
      [] -> {:error, query}
      [obj] -> {:ok, obj}
    end
  end

  @doc """
  Callback invoked for dynamically configuring the repo.

  It receives the repo configuration and checks if
  configuration should be loaded from the system environment.
  """
  @spec init(atom, Keyword.t()) :: {:ok, Keyword.t()} | no_return
  def init(_type, config) do
    if config[:load_from_system_env] do
      db_url =
        System.get_env("DATABASE_URL") ||
          raise("expected the DATABASE_URL environment variable to be set...")

      config = Keyword.put(config, :url, db_url)

      {:ok, config}
    else
      {:ok, config}
    end
  end
end
