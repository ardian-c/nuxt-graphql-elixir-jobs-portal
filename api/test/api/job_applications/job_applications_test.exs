defmodule Api.JobApplicationsTest do
  use Api.DataCase

  alias Api.JobApplications

  describe "job_applications" do
    alias Api.JobApplications.JobApplication

    @valid_attrs %{address: "some address", content: "some content", priority: 42, slug: "some slug", source: "some source", status: 42, title: "some title"}
    @update_attrs %{address: "some updated address", content: "some updated content", priority: 43, slug: "some updated slug", source: "some updated source", status: 43, title: "some updated title"}
    @invalid_attrs %{address: nil, content: nil, priority: nil, slug: nil, source: nil, status: nil, title: nil}

    def job_application_fixture(attrs \\ %{}) do
      {:ok, job_application} =
        attrs
        |> Enum.into(@valid_attrs)
        |> JobApplications.create_job_application()

      job_application
    end

    test "list_job_applications/0 returns all job_applications" do
      job_application = job_application_fixture()
      assert JobApplications.list_job_applications() == [job_application]
    end

    test "get_job_application!/1 returns the job_application with given id" do
      job_application = job_application_fixture()
      assert JobApplications.get_job_application!(job_application.id) == job_application
    end

    test "create_job_application/1 with valid data creates a job_application" do
      assert {:ok, %JobApplication{} = job_application} = JobApplications.create_job_application(@valid_attrs)
      assert job_application.address == "some address"
      assert job_application.content == "some content"
      assert job_application.priority == 42
      assert job_application.slug == "some slug"
      assert job_application.source == "some source"
      assert job_application.status == 42
      assert job_application.title == "some title"
    end

    test "create_job_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = JobApplications.create_job_application(@invalid_attrs)
    end

    test "update_job_application/2 with valid data updates the job_application" do
      job_application = job_application_fixture()
      assert {:ok, job_application} = JobApplications.update_job_application(job_application, @update_attrs)
      assert %JobApplication{} = job_application
      assert job_application.address == "some updated address"
      assert job_application.content == "some updated content"
      assert job_application.priority == 43
      assert job_application.slug == "some updated slug"
      assert job_application.source == "some updated source"
      assert job_application.status == 43
      assert job_application.title == "some updated title"
    end

    test "update_job_application/2 with invalid data returns error changeset" do
      job_application = job_application_fixture()
      assert {:error, %Ecto.Changeset{}} = JobApplications.update_job_application(job_application, @invalid_attrs)
      assert job_application == JobApplications.get_job_application!(job_application.id)
    end

    test "delete_job_application/1 deletes the job_application" do
      job_application = job_application_fixture()
      assert {:ok, %JobApplication{}} = JobApplications.delete_job_application(job_application)
      assert_raise Ecto.NoResultsError, fn -> JobApplications.get_job_application!(job_application.id) end
    end

    test "change_job_application/1 returns a job_application changeset" do
      job_application = job_application_fixture()
      assert %Ecto.Changeset{} = JobApplications.change_job_application(job_application)
    end
  end
end
