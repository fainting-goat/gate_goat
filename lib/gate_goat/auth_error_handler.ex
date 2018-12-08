defmodule GateGoat.AuthErrorHandler do
  use GateGoatWeb, :controller

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> redirect(to: "/login")
  end
end
