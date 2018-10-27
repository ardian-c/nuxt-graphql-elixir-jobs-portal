defmodule Api.DocumentsTest do
  use Api.DataCase

  alias Api.Documents

  describe "documents" do
    alias Api.Documents.Document

    @valid_attrs %{file_type: "some file_type", path: "some path", size: 42, type: "some type"}
    @update_attrs %{file_type: "some updated file_type", path: "some updated path", size: 43, type: "some updated type"}
    @invalid_attrs %{file_type: nil, path: nil, size: nil, type: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_document()

      document
    end

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert Documents.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Documents.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Documents.create_document(@valid_attrs)
      assert document.file_type == "some file_type"
      assert document.path == "some path"
      assert document.size == 42
      assert document.type == "some type"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, document} = Documents.update_document(document, @update_attrs)
      assert %Document{} = document
      assert document.file_type == "some updated file_type"
      assert document.path == "some updated path"
      assert document.size == 43
      assert document.type == "some updated type"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_document(document, @invalid_attrs)
      assert document == Documents.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Documents.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Documents.change_document(document)
    end
  end
end
