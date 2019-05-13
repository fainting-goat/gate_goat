defmodule GateGoatWeb.RegistrationView do
  use GateGoatWeb, :view

  #todo: turn boolean into registered/not registered

  def render_with_error(type, form, field) do

    if form.errors[field] do
      wrapper_class = "form-control form-errors-present"
      apply(Phoenix.HTML.Form, type, [form, field, [class: wrapper_class]])
    else
      wrapper_class = "form-control"
      apply(Phoenix.HTML.Form, type, [form, field, [class: wrapper_class]])
    end
  end

  def payment(%GateGoat.Events.Registration{registration_event_fee: fees}) do
    Enum.reduce(fees, Decimal.new(0), fn x, acc ->
      add_fees(x.selected, acc, x.event_fee.amount)
    end)
  end

  def add_fees(true, total, fee), do: Decimal.add(total, fee)
  def add_fees(false, total, _), do: total

  def event_name(event_id) do
    GateGoat.Events.get_event!(event_id).event_name
  end

  def fee_name(event_fee_id) do
    GateGoat.Events.get_event_fee!(event_fee_id).fee.name
  end

  def display_fee?(event_fee) do
    fee_name = GateGoat.Events.get_event_fee!(event_fee.id).fee.name
    display_fee?(event_fee.amount, fee_name, event_fee.event_id)
  end
  def display_fee?(%Decimal{coef: 0}, _, _), do: false
  def display_fee?(_, "Site", _), do: false
  def display_fee?(_, "Feast", event_id) do
    GateGoat.Events.get_event!(event_id).feast_available
  end
  def display_fee?(_, _, _), do: true

  def checks_payable(event_id) do
    GateGoat.Events.get_event!(event_id).checks_payable
  end

  def get_non_member_surcharge(false), do: 5
  def get_non_member_surcharge(true), do: 0
end
