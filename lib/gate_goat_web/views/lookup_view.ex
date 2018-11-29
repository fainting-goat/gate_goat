defmodule GateGoatWeb.LookupView do
  use GateGoatWeb, :view

  def payment(params) do
    GateGoatWeb.RegistrationView.payment(params)
  end

  def checks_payable(params) do
    GateGoatWeb.RegistrationView.checks_payable(params)
  end

  def get_events() do
    GateGoat.Events.list_current_events()
  end
end
