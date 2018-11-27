defmodule GateGoatWeb.LookupController do
  use GateGoatWeb, :controller

  alias GateGoat.Events

  def lookup(conn, %{"search" => %{"confirmation_number" => registration_id}}) do
    if Regex.match?(~r/^\d+$/, registration_id) do
      registration = Events.get_registration(registration_id)
      render_results(conn, registration)
    else
      render_results(conn)
    end
  end
  def lookup(conn, %{"registration" => registration_id}) do
    registration = Events.get_registration(registration_id)
    Events.update_registration(registration, %{verified: true})

    conn
    |> put_flash(:info, "User verified.")
    |> render("lookup.html", verified: true, error: false)
  end
  def lookup(conn, _params) do
    render(conn, "lookup.html", error: false)
  end

  defp render_results(conn, nil), do: render_results(conn)
  defp render_results(conn, registration), do: render(conn, "display.html", registration: registration)
  defp render_results(conn), do: render(conn, "lookup.html", error: true)
end
