defmodule ApiWeb.DocumentController do
  use ApiWeb, :controller

  alias Api.Documents
  # alias Api.Documents.Document

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    documents = Documents.list_documents()
    render(conn, "index.json", documents: documents)
  end

#  def create(conn, %{"document" => document_params}) do
#    with {:ok, %Document{} = document} <- Documents.create_document(document_params) do
#      conn
#      |> put_status(:created)
#      |> put_resp_header("location", document_path(conn, :show, document))
#      |> render("show.json", document: document)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    document = Documents.get_document!(id)
#    render(conn, "show.json", document: document)
#  end
#
#  def update(conn, %{"id" => id, "document" => document_params}) do
#    document = Documents.get_document!(id)
#
#    with {:ok, %Document{} = document} <- Documents.update_document(document, document_params) do
#      render(conn, "show.json", document: document)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    document = Documents.get_document!(id)
#    with {:ok, %Document{}} <- Documents.delete_document(document) do
#      send_resp(conn, :no_content, "")
#    end
#  end
end
