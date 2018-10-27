defmodule ApiWeb.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    # IO.inspect [context: context]
    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
          %{ current_user: current_user }
    else
      nil ->
        {:error, "Unauthorized 401"}
      _ ->
        %{}
    end
  end

  defp authorize(token) do
    case Api.Guardian.decode_and_verify(token) do
      {:ok, claims} -> Api.Guardian.resource_from_claims(claims)
      {:error, reason} -> {:error, reason}
      nil -> {:error, "Unauthorized 422"}
    end
  end
end