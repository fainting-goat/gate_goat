defmodule GateGoatWeb.UserView do
  use GateGoatWeb, :view

  def get_roles() do
    GateGoat.Users.list_roles()
  end

  def get_events() do
    GateGoat.Events.list_current_events()
  end

  def sanitize_event(event) do
    if event == nil do
      "Unassigned"
    else
      event.event_name
    end
  end
end
