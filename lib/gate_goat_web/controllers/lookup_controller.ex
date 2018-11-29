defmodule GateGoatWeb.LookupController do
  use GateGoatWeb, :controller

  alias GateGoat.Events

  def lookup(conn, %{"action" => "disable", "feast" => %{"event" => event_id}}) do
    render_feast_change(conn, event_id, false, "disabled")
  end
  def lookup(conn, %{"action" => "enable", "feast" => %{"event" => event_id}}) do
    render_feast_change(conn, event_id, true, "enabled")
  end
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

  defp render_feast_change(conn, event_id, option, message) do
    event = Events.get_event!(String.to_integer(event_id))
    Events.update_event(event, %{feast_available: option})

    conn
    |> put_flash(:info, "Feast #{message} for #{event.event_name}.")
    |> render("lookup.html", verified: true, error: false)
  end
end
