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

  pipeline :admin do
    plug GateGoat.AdminUser
  end

  pipeline :event_manager do
    plug GateGoat.EventManagerUser
  end

  scope "/", GateGoatWeb do
    pipe_through [:protected, :admin, :browser]

    resources "/fees", FeeController
    resources "/users", UserController, only: [:index, :delete, :show, :create, :new]
    resources "/register", RegistrationController, only: [:index, :delete]
    resources "/roles", RoleController
  end

  scope "/", GateGoatWeb do
    pipe_through [:protected, :event_manager, :browser]

    resources "/events", EventController do
      resources "/activities", ActivityController, only: [:create, :new, :edit]
    end

    resources "/activities", ActivityController, only: [:index, :delete, :create, :new, :edit, :update]
  end

  scope "/", GateGoatWeb do
    pipe_through [:protected, :browser]

    resources "/register", RegistrationController, only: [:edit, :update]
    resources "/users", UserController, only: [:edit, :update]

    get "/admin", AdminController, :index
    get "/lookup", LookupController, :lookup
    post "/lookup", LookupController, :lookup
  end

  scope "/", GateGoatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", GateGoatController, :index
    get "/about", GateGoatController, :about
    get "/instructions", GateGoatController, :instructions
    get "/event/:id", GateGoatController, :register
    resources "/register", RegistrationController, only: [:show, :create, :new]
    resources "/activities", ActivityController, only: [:index, :show]

    resources "/events", EventController do
      resources "/activities", ActivityController, only: [:index]
    end

    get "/login", LoginController, :login
    post "/login", LoginController, :login
    post "/logout", LoginController, :logout
  end


  # Other scopes may use custom stacks.
  # scope "/api", GateGoatWeb do
  #   pipe_through :api
  # end
end
