defmodule GateGoatWeb.LookupController do
  use GateGoatWeb, :controller

  alias GateGoat.Events
  alias GateGoat.Events.Event
  alias GateGoat.Events.Registration

  def lookup(conn, %{"search" => %{"confirmation_number" => registration_id}}) do
    if Regex.match?(~r/^\d+$/, registration_id) do
      registration = Events.get_registration(registration_id)
      render_results(conn, registration)
    else
      render_results(conn)
    end
  end
  def lookup(conn, _params) do
    render(conn, "lookup.html", error: false)
  end

  defp render_results(conn, nil), do: render_results(conn)
  defp render_results(conn, registration), do: render(conn, "display.html", registration: registration)
  defp render_results(conn), do: render(conn, "lookup.html", error: true)
end
