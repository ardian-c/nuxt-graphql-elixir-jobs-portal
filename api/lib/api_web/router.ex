defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ApiWeb.Context
  end

  scope "/api/v1" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
      schema: ApiWeb.Schema

    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: ApiWeb.Schema
    end
  end
end
