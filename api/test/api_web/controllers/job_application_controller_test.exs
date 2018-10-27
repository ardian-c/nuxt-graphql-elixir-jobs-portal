defmodule ApiWeb.JobApplicationControllerTest do
  use ApiWeb.ConnCase

  alias Api.JobApplications
  alias Api.JobApplications.JobApplication

  @create_attrs %{address: "some address", content: "some content", priority: 42, slug: "some slug", source: "some source", status: 42, title: "some title"}
  @update_attrs %{address: "some updated address", content: "some updated content", priority: 43, slug: "some updated slug", source: "some updated source", status: 43, title: "some updated title"}
  @invalid_attrs %{address: nil, content: nil, priority: nil, slug: nil, source: nil, status: nil, title: nil}

  def fixture(:job_application) do
    {:ok, job_application} = JobApplications.create_job_application(@create_attrs)
    job_application
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all job_applications", %{conn: conn} do
      conn = get conn, job_application_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create job_application" do
    test "renders job_application when data is valid", %{conn: conn} do
      conn = post conn, job_application_path(conn, :create), job_application: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, job_application_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "address" => "some address",
        "content" => "some content",
        "priority" => 42,
        "slug" => "some slug",
        "source" => "some source",
        "status" => 42,
        "title" => "some title"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, job_application_path(conn, :create), job_application: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update job_application" do
    setup [:create_job_application]

    test "renders job_application when data is valid", %{conn: conn, job_application: %JobApplication{id: id} = job_application} do
      conn = put conn, job_application_path(conn, :update, job_application), job_application: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, job_application_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "address" => "some updated address",
        "content" => "some updated content",
        "priority" => 43,
        "slug" => "some updated slug",
        "source" => "some updated source",
        "status" => 43,
        "title" => "some updated title"}
    end

    test "renders errors when data is invalid", %{conn: conn, job_application: job_application} do
      conn = put conn, job_application_path(conn, :update, job_application), job_application: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete job_application" do
    setup [:create_job_application]

    test "deletes chosen job_application", %{conn: conn, job_application: job_application} do
      conn = delete conn, job_application_path(conn, :delete, job_application)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, job_application_path(conn, :show, job_application)
      end
    end
  end

  defp create_job_application(_) do
    job_application = fixture(:job_application)
    {:ok, job_application: job_application}
  end
end
