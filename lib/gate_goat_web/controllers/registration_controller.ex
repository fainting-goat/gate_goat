defmodule GateGoatWeb.RegistrationController do
  use GateGoatWeb, :controller

  alias GateGoat.Registrations
  alias GateGoat.Registrations.Registration

  def index(conn, _params) do
    registrations = if GateGoat.AdminHelper.admin?(conn) do
      Registrations.list_registrations_events()
    else
      Registrations.list_registrations(GateGoat.AdminHelper.current_user(conn).event_id)
    end
    render(conn, "index.html", registrations: registrations)
  end

  def new(conn, %{"event_id" => event_id}) do
    changeset = Registrations.new_registration_with_fees(event_id)
    render(conn, "new.html", changeset: changeset, event_id: event_id)
  end
  def new(conn, _params) do
    changeset = Registrations.change_registration(%Registration{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => registration_params, "event_id" => event_id}) do
    case Registrations.create_registration(registration_params, event_id) do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration created successfully.")
        |> redirect(to: Routes.registration_path(conn, :show, registration, event_id: event_id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, event_id: event_id)
    end
  end

  def show(conn, %{"id" => id}) do
    registration = Registrations.get_registration!(id)
    render(conn, "show.html", registration: registration)
  end

  def edit(conn, %{"id" => id}) do
    registration = Registrations.get_registration!(id)
    changeset = Registrations.change_registration(registration)
    render(conn, "edit.html", registration: registration, changeset: changeset)
  end

  def update(conn, %{"id" => id, "registration" => registration_params}) do
    registration = Registrations.get_registration!(id)

    case Registrations.update_registration(registration, registration_params) do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration updated successfully.")
        |> redirect(to: Routes.lookup_path(conn, :lookup, %{"search" => %{"confirmation_number" => registration.id}}))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", registration: registration, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    registration = Registrations.get_registration!(id)
    {:ok, _registration} = Registrations.delete_registration(registration)

    conn
    |> put_flash(:info, "Registration deleted successfully.")
    |> redirect(to: Routes.registration_path(conn, :index))
  end
end
