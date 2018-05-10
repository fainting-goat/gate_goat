defmodule GateGoatWeb.RegistrationController do
  use GateGoatWeb, :controller

  alias GateGoat.Events
  alias GateGoat.Events.Registration

  def index(conn, %{"event_id" => event_id}) do
    registrations = Events.list_registrations(event_id)
    render(conn, "index.html", registrations: registrations, event_id: event_id)
  end
  def index(conn, params) do
    registrations = Events.list_registrations()
    render(conn, "index.html", registrations: registrations)
  end

  def new(conn, %{"event_id" => event_id}) do
    changeset = Events.change_registration(%Registration{})
    render(conn, "new.html", changeset: changeset, event_id: event_id)
  end
  def new(conn, _params) do
    changeset = Events.change_registration(%Registration{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => registration_params, "event_id" => event_id}) do
    case Events.create_registration(registration_params, event_id) do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration created successfully.")
        |> redirect(to: registration_path(conn, :show, registration, event_id: event_id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, event_id: event_id)
    end
  end

  def show(conn, %{"id" => id}) do
    registration = Events.get_registration!(id)
    render(conn, "show.html", registration: registration)
  end

  def edit(conn, %{"id" => id}) do
    registration = Events.get_registration!(id)
    changeset = Events.change_registration(registration)
    render(conn, "edit.html", registration: registration, changeset: changeset)
  end

  def update(conn, %{"id" => id, "registration" => registration_params}) do
    registration = Events.get_registration!(id)

    case Events.update_registration(registration, registration_params) do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration updated successfully.")
        |> redirect(to: registration_path(conn, :show, registration))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", registration: registration, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    registration = Events.get_registration!(id)
    {:ok, _registration} = Events.delete_registration(registration)

    conn
    |> put_flash(:info, "Registration deleted successfully.")
    |> redirect(to: registration_path(conn, :index))
  end
end
