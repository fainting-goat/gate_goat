defmodule GateGoatWeb.GateGoatController do
  use GateGoatWeb, :controller

  alias GateGoat.Events

  def index(conn, _params) do
    events = Events.list_current_events()
    render(conn, "index.html", events: events)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def instructions(conn, _params) do
    render(conn, "instructions.html")
  end

  def register(conn, %{"id" => event_id}) do
    redirect(conn, to: Routes.registration_path(conn, :new, event_id: event_id))
  end
end
