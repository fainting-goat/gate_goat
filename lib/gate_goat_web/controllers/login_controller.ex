#defmodule GateGoatWeb.LoginController do
#  use GateGoatWeb, :controller
##  alias DndManager.User
#
#  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
#
#  def login(conn, %{"username" => username, "password" => password}) do
#    result = {:ok, conn}
##    user = Repo.get_by(User, username: username)
##
##    result = cond do
##      user && checkpw(password, user.password_hash) ->
##        {:ok, login_user(conn, user)}
##      user -> {:error, conn}
##      true ->
##        dummy_checkpw
##        {:error, conn}
##    end
#
#    case result do
#      {:ok, conn} ->
#        conn
#        |> put_flash(:info, "You’re now logged in!")
#        |> redirect(to: Routes.event_path(conn, :index))
#      {:error, conn} ->
#        conn
#        |> put_flash(:error, "Invalid email/password combination")
#        |> render("login.html")
#    end
#  end
#  def login(conn, _params) do
#    render(conn, "login.html")
#  end
#
##  defp login_user(conn, user) do
##    conn
##    |> DndManager.Guardian.Plug.sign_in(user)
##  end
#end
