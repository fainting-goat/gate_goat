defmodule GateGoat.Users do

  import Ecto.Query, warn: false
  alias GateGoat.Repo
  alias GateGoat.Users.User

  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  def get_user_by_username!(username), do: Repo.get_by!(User, username: username)
  def get_user_by_username(username), do: Repo.get_by(User, username: username)
end
