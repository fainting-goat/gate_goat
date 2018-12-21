defmodule GateGoat.AdminUser do
  use GateGoatWeb, :controller

  import Plug.Conn
  import Guardian.Plug
  def init(opts), do: opts
  def call(conn, _opts) do
    %{id: user_id} = current_resource(conn)

    user = GateGoat.Users.get_user!(user_id)

    case user.role.type do
      "admin" -> conn
      _ -> redirect(conn, to: "/login")
    end
  end
end
