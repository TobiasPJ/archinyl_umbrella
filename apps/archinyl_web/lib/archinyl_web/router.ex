defmodule ArchinylWeb.Router do
  use ArchinylWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ArchinylWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ArchinylWeb.Telemetry
    end
  end

  scope "/", ArchinylWeb do
    pipe_through :browser

    live "/library", LibraryLive, :library
    live "/collection", CollectionLive, :collection
    live "/records", RecordsLive, :record
    live "/artists", ArtistsLive, :artist

    resources "/registration", RegistrationController, only: [:new, :create]
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/go_to_collection:collection_id", SessionController, :collection
    get "/*path", SessionController, :empty_path
  end
end
