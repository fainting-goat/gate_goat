defmodule GateGoatWeb.RegistrationView do
  use GateGoatWeb, :view

  def payment(%GateGoat.Events.Registration{feast_option: feast_option, camping_option: camping_option, event_id: event_id}) do
    get_event_fee(event_id) + get_feast_fee(event_id, feast_option) + get_camping_fee(event_id, camping_option)
  end

  def event_name(event_id) do
    GateGoat.Events.get_event!(event_id).event_name
  end

  defp get_event_fee(event_id) do
    GateGoat.Events.get_event!(event_id).event_fee
  end

  defp get_feast_fee(_, false), do: 0
  defp get_feast_fee(event_id, true) do
    GateGoat.Events.get_event!(event_id).feast_fee
  end

  defp get_camping_fee(_, false), do: 0
  defp get_camping_fee(event_id, true) do
    GateGoat.Events.get_event!(event_id).camping_fee
  end
end
