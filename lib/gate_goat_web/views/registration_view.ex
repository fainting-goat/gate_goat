defmodule GateGoatWeb.RegistrationView do
  use GateGoatWeb, :view

  def payment(feast_option) do
    if feast_option == true do
      "$20"
    else
      "$10"
    end
  end
end
