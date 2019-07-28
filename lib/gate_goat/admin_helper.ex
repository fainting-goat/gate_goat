defmodule GateGoat.AdminHelper do
  def admin?(conn) do
    if conn.assigns[:current_user] != nil do
      current_user(conn).role.type == "admin"
    else
      false
    end
  end

  def event_manager?(conn) do
    if conn.assigns[:current_user] != nil do
      current_user(conn).role.type == "event_manager"
    else
      false
    end
  end

  def user_id(conn) do
    %{id: user_id} = conn.assigns[:current_user]
    user_id
  end

  def current_user(conn) do
    GateGoat.Users.get_user!(user_id(conn))
  end
end
