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

  pipeline :protected do
    plug :fetch_session
    plug Guardian.Plug.Pipeline, module: GateGoat.Guardian,
                                 error_handler: GateGoat.AuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug GateGoat.CurrentUser
  end

  scope "/", GateGoatWeb do
    pipe_through [:protected, :browser]

    get "/admin", AdminController, :index
    resources "/events", EventController
    resources "/register", RegistrationController, only: [:index, :edit, :delete, :update]

    get "/lookup", LookupController, :lookup
    post "/lookup", LookupController, :lookup
  end

  scope "/", GateGoatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", GateGoatController, :index
    get "/about", GateGoatController, :about
    get "/event/:id", GateGoatController, :register
    resources "/register", RegistrationController, only: [:show, :create, :new]

    get "/login", LoginController, :login
    post "/login", LoginController, :login
    post "/logout", LoginController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", GateGoatWeb do
  #   pipe_through :api
  # end
end
