defmodule GateGoatWeb.Router do
  use GateGoatWeb, :router

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

  scope "/", GateGoatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", GateGoatController, :index
    get "/lookup", LookupController, :lookup
    post "/lookup", LookupController, :lookup
    get "/event/:id", GateGoatController, :register
    resources "/register", RegistrationController, only: [:index, :show, :create, :new]
#    resources "/events", EventController
  end

  # Other scopes may use custom stacks.
  # scope "/api", GateGoatWeb do
  #   pipe_through :api
  # end
end
