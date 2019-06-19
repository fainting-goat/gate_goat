defmodule GateGoatWeb.GateGoatView do
  use GateGoatWeb, :view

  def assign_event(conn, event_id) do
    conn
    |> Plug.Conn.put_session(:event, event_id)
  end
end
