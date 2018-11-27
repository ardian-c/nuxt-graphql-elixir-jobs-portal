defmodule ApiWeb.Resolvers.Categories do
	require Logger

	alias Api.Repo
	alias Api.Categories
	alias Api.Categories.Category


	@desc "Categories get all"
  def get_all_categories(_, %{ offset: offset, keyword: keyword }, _) do
    categories = Category
        |> Categories.search(keyword)
        |> Repo.paginate(offset)
        |> Repo.all()
    {:ok, categories}
  end

  @desc "Categories get all - order by posts"
  def get_all_categories_order_by_posts(_, %{}, _) do
    res = Category
        |> Categories.with_posts_count()
        |> Repo.all()
    {:ok, res}
  end

  @desc "Categories get all - no pagination"
  def get_all_categories_no_pagination(_, %{}, _) do
    companies = Category
        |> Repo.all()

    {:ok, companies}
  end

  @desc "Category get by id"
  def get_by_id(_, %{ id: id}, _) do
    case Repo.get_by!(Category, id: id) do
      category ->
        {:ok, category}
      nil ->
        {:error, "Something went wrong, no such category"}
    end
  end

  @desc "Category get by name or description"
  def get_by_name_or_description(_, %{ keyword: keyword }, _) do
  	categories = Category
  			|> Categories.search(keyword)
        |> Repo.all()
  	{:ok, categories}
  end

  @desc "Category add new"
  def add_category(_, %{ input: params }, _) do
    with {:ok, %Category{} = category} <- Categories.create_category(params) do
      {:ok, category}
    end
  end

  @desc "Category delete"
  def delete_category(_, %{ category_id: category_id}, _) do
    category = Category
              |> Repo.get!(category_id)

    if category |> Categories.delete_category() do
      res = %{code: 200, message: 'Category deleted successfully!'}
      {:ok, res }
    else
      res = %{code: 401, message: 'Something went wrong!'}
      {:error, res }
    end
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
