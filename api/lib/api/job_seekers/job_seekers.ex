defmodule Api.JobSeekers do
  @moduledoc """
  The JobSeekers context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.JobSeekers.JobSeeker

  @doc """
  Returns the list of job_seekers.

  ## Examples

      iex> list_job_seekers()
      [%JobSeeker{}, ...]

  """
  def list_job_seekers do
    Repo.all(JobSeeker)
  end

  @doc """
  Gets a single job_seeker.

  Raises `Ecto.NoResultsError` if the Job seeker does not exist.

  ## Examples

      iex> get_job_seeker!(123)
      %JobSeeker{}

      iex> get_job_seeker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job_seeker!(id), do: Repo.get!(JobSeeker, id)

  @doc """
  Creates a job_seeker.

  ## Examples

      iex> create_job_seeker(%{field: value})
      {:ok, %JobSeeker{}}

      iex> create_job_seeker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job_seeker(attrs \\ %{}) do
    %JobSeeker{}
    |> JobSeeker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job_seeker.

  ## Examples

      iex> update_job_seeker(job_seeker, %{field: new_value})
      {:ok, %JobSeeker{}}

      iex> update_job_seeker(job_seeker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job_seeker(%JobSeeker{} = job_seeker, attrs) do
    job_seeker
    |> JobSeeker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a JobSeeker.

  ## Examples

      iex> delete_job_seeker(job_seeker)
      {:ok, %JobSeeker{}}

      iex> delete_job_seeker(job_seeker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job_seeker(%JobSeeker{} = job_seeker) do
    Repo.delete(job_seeker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job_seeker changes.

  ## Examples

      iex> change_job_seeker(job_seeker)
      %Ecto.Changeset{source: %JobSeeker{}}

  """
  def change_job_seeker(%JobSeeker{} = job_seeker) do
    JobSeeker.changeset(job_seeker, %{})
  end
end
