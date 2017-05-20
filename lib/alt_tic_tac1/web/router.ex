defmodule AltTicTac1.Web.Router do
  use AltTicTac1.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AltTicTac1.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/start", PageController, :start_game
    get "/join/:id", PageController, :join_game
  end

  # Other scopes may use custom stacks.
  # scope "/api", AltTicTac1.Web do
  #   pipe_through :api
  # end
end
