defmodule GateGoatWeb.ActivityView do
  use GateGoatWeb, :view

  def items_changed(activity) do
    new_activity = activity.replaced_by_id
    |> GateGoat.Activities.get_activity!()
    |> Map.from_struct()

    activity = activity
    |> Map.from_struct()
    |> Map.delete(:event)
    |> Map.delete(:replaced_by_id)
    |> Map.delete(:id)
    |> Map.delete(:inserted_at)
    |> Map.delete(:created_at)

    Enum.reduce(activity, [], fn({key, value}, acc) ->
      if value != new_activity[key] do
        proper_name = key
        |> Atom.to_string()
        |> String.replace("_", " ")
        |> String.capitalize()
        [%{name: proper_name, old_value: make_human_readable(value), new_value: make_human_readable(new_activity[key])} | acc]
      else
        acc
      end
    end)
  end

  def make_human_readable(%NaiveDateTime{} = datetime) do
    "#{datetime.month}/#{datetime.day} at #{format_time(datetime.hour, datetime.minute)}"
  end
  def make_human_readable(value), do: value

  defp format_minutes(minute) do
    if minute < 10 do
      "0#{minute}"
    else
      minute
    end
  end

  defp format_time(hour, minute) do
    if hour > 12 do
      "#{hour - 12}:#{format_minutes(minute)} PM"
    else
      "#{hour}:#{format_minutes(minute)} AM"
    end
  end
end
