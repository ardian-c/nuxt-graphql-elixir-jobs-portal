defmodule ApiWeb.DocumentView do
  use ApiWeb, :view
  alias ApiWeb.DocumentView

  def render("index.json", %{documents: documents}) do
    %{data: render_many(documents, DocumentView, "document.json")}
  end

  def render("show.json", %{document: document}) do
    %{data: render_one(document, DocumentView, "document.json")}
  end

  def render("document.json", %{document: document}) do
    %{id: document.id,
      path: document.path,
      size: document.size,
      file_type: document.file_type,
      type: document.type}
  end
end
