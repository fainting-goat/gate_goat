defmodule GateGoatWeb.GateGoatController do
  use GateGoatWeb, :controller

  alias GateGoat.Events
  alias GateGoat.Events.Event
  alias GateGoat.Events.Registration

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, "index.html", events: events)
  end

  def register(conn, %{"id" => event_id}) do
    redirect(conn, to: registration_path(conn, :index, event_id: event_id))
  end
end
