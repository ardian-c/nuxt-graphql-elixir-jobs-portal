defmodule Api.JobApplications.JobApplicationCategories do
  @moduledoc """
  The JobApplicationCategories context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.JobApplications.JobApplicationCategory

  @doc """
  Returns the list of job_applications.

  ## Examples

      iex> list_job_applications()
      [%JobApplication{}, ...]

  """
  def list_job_application_categories do
    Repo.all(JobApplicationCategory)
  end


  @doc """
  Gets a single job_application.

  Raises `Ecto.NoResultsError` if the Job application does not exist.

  ## Examples

      iex> get_job_application!(123)
      %JobApplication{}

      iex> get_job_application!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job_application_category!(id), do: Repo.get!(JobApplicationCategory, id)


  @doc """
  Creates a job_application.

  ## Examples

      iex> create_job_application(%{field: value})
      {:ok, %JobApplication{}}

      iex> create_job_application(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job_application_category(attrs \\ %{}) do
    %JobApplicationCategory{}
    |> JobApplicationCategory.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Updates a job_application.

  ## Examples

      iex> update_job_application(job_application, %{field: new_value})
      {:ok, %JobApplication{}}

      iex> update_job_application(job_application, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job_application_category(%JobApplicationCategory{} = job_application_category, attrs) do
    job_application_category
    |> JobApplicationCategory.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Deletes a JobApplication.

  ## Examples

      iex> delete_job_application(job_application)
      {:ok, %JobApplication{}}

      iex> delete_job_application(job_application)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job_application_category(%JobApplicationCategory{} = job_application_category) do
    Repo.delete(job_application_category)
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job_application changes.

  ## Examples

      iex> change_job_application(job_application)
      %Ecto.Changeset{source: %JobApplication{}}

  """
  def change_job_application(%JobApplicationCategory{} = job_application_category) do
    JobApplicationCategory.changeset(job_application_category, %{})
  end
end