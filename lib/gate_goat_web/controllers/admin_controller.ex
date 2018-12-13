defmodule GateGoatWeb.AdminController do
  use GateGoatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
