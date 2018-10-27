defmodule ApiWeb.JobSeekerControllerTest do
  use ApiWeb.ConnCase

  alias Api.JobSeekers
  alias Api.JobSeekers.JobSeeker

  @create_attrs %{description: "some description", profession: "some profession"}
  @update_attrs %{description: "some updated description", profession: "some updated profession"}
  @invalid_attrs %{description: nil, profession: nil}

  def fixture(:job_seeker) do
    {:ok, job_seeker} = JobSeekers.create_job_seeker(@create_attrs)
    job_seeker
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all job_seekers", %{conn: conn} do
      conn = get conn, job_seeker_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create job_seeker" do
    test "renders job_seeker when data is valid", %{conn: conn} do
      conn = post conn, job_seeker_path(conn, :create), job_seeker: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, job_seeker_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "profession" => "some profession"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, job_seeker_path(conn, :create), job_seeker: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update job_seeker" do
    setup [:create_job_seeker]

    test "renders job_seeker when data is valid", %{conn: conn, job_seeker: %JobSeeker{id: id} = job_seeker} do
      conn = put conn, job_seeker_path(conn, :update, job_seeker), job_seeker: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, job_seeker_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some updated description",
        "profession" => "some updated profession"}
    end

    test "renders errors when data is invalid", %{conn: conn, job_seeker: job_seeker} do
      conn = put conn, job_seeker_path(conn, :update, job_seeker), job_seeker: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete job_seeker" do
    setup [:create_job_seeker]

    test "deletes chosen job_seeker", %{conn: conn, job_seeker: job_seeker} do
      conn = delete conn, job_seeker_path(conn, :delete, job_seeker)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, job_seeker_path(conn, :show, job_seeker)
      end
    end
  end

  defp create_job_seeker(_) do
    job_seeker = fixture(:job_seeker)
    {:ok, job_seeker: job_seeker}
  end
end
