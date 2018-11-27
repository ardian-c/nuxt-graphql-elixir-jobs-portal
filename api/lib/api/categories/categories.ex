defmodule Api.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Categories.Category
  alias Api.JobApplications.JobApplicationCategory;

  def search(query, nil), do: query

  def search(query, keyword) do
    from(
      r in query,
      where: ilike(r.name, ^"%#{keyword}%") or ilike(r.description, ^"%#{keyword}%"),
      order_by: [desc: :inserted_at]
    )
  end

  def with_posts_count(query, nil), do: query

  def with_posts_count(query) do
    from(
      jc in JobApplicationCategory,
      join: c in "categories", on: jc.category_id == c.id,
      join: j in "job_applications", on: jc.job_application_id == j.id,
      group_by: [jc.category_id, c.name],
      order_by: [desc: count(jc.job_application_id)],
      select: %{
        id: jc.category_id,
        name: c.name,
        count_posts: count(jc.job_application_id)
      },
      limit: 10
    )
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
