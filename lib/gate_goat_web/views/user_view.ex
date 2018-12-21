defmodule GateGoatWeb.UserView do
  use GateGoatWeb, :view

  def get_roles() do
    GateGoat.Users.list_roles()
  end
end
