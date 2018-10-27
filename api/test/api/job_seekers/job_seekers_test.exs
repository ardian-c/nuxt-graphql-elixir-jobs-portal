defmodule Api.JobSeekersTest do
  use Api.DataCase

  alias Api.JobSeekers

  describe "job_seekers" do
    alias Api.JobSeekers.JobSeeker

    @valid_attrs %{description: "some description", profession: "some profession"}
    @update_attrs %{description: "some updated description", profession: "some updated profession"}
    @invalid_attrs %{description: nil, profession: nil}

    def job_seeker_fixture(attrs \\ %{}) do
      {:ok, job_seeker} =
        attrs
        |> Enum.into(@valid_attrs)
        |> JobSeekers.create_job_seeker()

      job_seeker
    end

    test "list_job_seekers/0 returns all job_seekers" do
      job_seeker = job_seeker_fixture()
      assert JobSeekers.list_job_seekers() == [job_seeker]
    end

    test "get_job_seeker!/1 returns the job_seeker with given id" do
      job_seeker = job_seeker_fixture()
      assert JobSeekers.get_job_seeker!(job_seeker.id) == job_seeker
    end

    test "create_job_seeker/1 with valid data creates a job_seeker" do
      assert {:ok, %JobSeeker{} = job_seeker} = JobSeekers.create_job_seeker(@valid_attrs)
      assert job_seeker.description == "some description"
      assert job_seeker.profession == "some profession"
    end

    test "create_job_seeker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = JobSeekers.create_job_seeker(@invalid_attrs)
    end

    test "update_job_seeker/2 with valid data updates the job_seeker" do
      job_seeker = job_seeker_fixture()
      assert {:ok, job_seeker} = JobSeekers.update_job_seeker(job_seeker, @update_attrs)
      assert %JobSeeker{} = job_seeker
      assert job_seeker.description == "some updated description"
      assert job_seeker.profession == "some updated profession"
    end

    test "update_job_seeker/2 with invalid data returns error changeset" do
      job_seeker = job_seeker_fixture()
      assert {:error, %Ecto.Changeset{}} = JobSeekers.update_job_seeker(job_seeker, @invalid_attrs)
      assert job_seeker == JobSeekers.get_job_seeker!(job_seeker.id)
    end

    test "delete_job_seeker/1 deletes the job_seeker" do
      job_seeker = job_seeker_fixture()
      assert {:ok, %JobSeeker{}} = JobSeekers.delete_job_seeker(job_seeker)
      assert_raise Ecto.NoResultsError, fn -> JobSeekers.get_job_seeker!(job_seeker.id) end
    end

    test "change_job_seeker/1 returns a job_seeker changeset" do
      job_seeker = job_seeker_fixture()
      assert %Ecto.Changeset{} = JobSeekers.change_job_seeker(job_seeker)
    end
  end
end
