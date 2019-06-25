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

  def feast_available(event) do
    if event.feast_available == true do
      "enabled"
    else
      "disabled"
    end
  end

  def feast_selected?(registration) do
    registration.registration_event_fee
    |> Enum.any?(fn(reg) -> reg.event_fee.fee.name == "Feast" && reg.selected end)
  end

  def feast_change(true, false), do: true
  def feast_change(_, _), do: false
end
