defmodule GateGoatWeb.RegistrationController do
  use GateGoatWeb, :controller

  alias GateGoat.Events
  alias GateGoat.Events.Registration

  def index(conn, _params) do
    registrations = Events.list_registrations()
    render(conn, "index.html", registrations: registrations)
  end

  def new(conn, _params) do
    changeset = Events.change_registration(%Registration{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => registration_params}) do
    case Events.create_registration(registration_params) do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration created successfully.")
        |> redirect(to: registration_path(conn, :show, registration))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
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
