defmodule GateGoatWeb.RegistrationView do
  use GateGoatWeb, :view

  def render_with_error(type, form, field) do

    if form.errors[field] do
      wrapper_class = "form-control form-errors-present"
      apply(Phoenix.HTML.Form, type, [form, field, [class: wrapper_class]])
    else
      wrapper_class = "form-control"
      apply(Phoenix.HTML.Form, type, [form, field, [class: wrapper_class]])
    end
  end

  def payment(%GateGoat.Events.Registration{feast_option: feast_option, camping_option: camping_option, event_id: event_id}) do
    get_event_fee(event_id) + get_feast_fee(event_id, feast_option) + get_camping_fee(event_id, camping_option)
  end

  def event_name(event_id) do
    GateGoat.Events.get_event!(event_id).event_name
  end

  def checks_payable(event_id) do
    GateGoat.Events.get_event!(event_id).checks_payable
  end

  defp get_event_fee(event_id) do
    GateGoat.Events.get_event!(event_id).event_fee
  end

  def get_feast_fee(_, false), do: 0
  def get_feast_fee(event_id, true) do
    GateGoat.Events.get_event!(event_id).feast_fee
  end
  def get_feast_fee(event_id), do: get_feast_fee(event_id, true)

  def get_camping_fee(_, false), do: 0
  def get_camping_fee(event_id, true) do
    GateGoat.Events.get_event!(event_id).camping_fee
  end
  def get_camping_fee(event_id), do: get_feast_fee(event_id, true)
end
