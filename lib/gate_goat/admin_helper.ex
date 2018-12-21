defmodule GateGoat.AdminHelper do
  def admin?(conn) do
    user = GateGoat.Users.get_user!(user_id(conn))

    user.role.type == "admin"
  end

  def user_id(conn) do
    %{id: user_id} = conn.assigns[:current_user]
    user_id
  end
end
