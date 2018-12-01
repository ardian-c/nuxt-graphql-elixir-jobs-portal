defmodule ApiWeb.Resolvers.Cities do

  alias Api.Repo
  alias Api.Cities
  alias Api.Cities.City

  @desc "Cities - get all"
  def get_all_cities_no_pagination(_, %{}, _) do
    cities = City
      |> Repo.all()

    {:ok, cities}
  end

  @desc "Cities - get all ordered by posts"
  def get_all_cities_order_by_posts(_, %{}, _) do
    cities = City
           |> Cities.with_posts_count()
           |> Repo.all()
    {:ok, cities}
  end

#  @desc "Cities - get all paginated"
#  def get_all_categories(_, %{offset: offset, keyword: keyword}, _) do
#
#  end
end