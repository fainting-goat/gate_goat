defmodule GateGoat.Helpers do
  def human_to_elixir_date(nil), do: nil
  def human_to_elixir_date(date) do
    if date =~ "/" do
      [month, day, year] = String.split(date, "/")

      day = if String.length(day) == 1 do
        "0#{day}"
      else
        day
      end

      "#{year}-#{month}-#{day}"
    else
      date
    end
  end

  def elixir_to_human_date(date) do
    date = Date.to_string(date)

    if String.match?(date, ~r/\d\d\d\d\-\d\d\-\d\d/) do
      [year, month, day] = String.split(date, "-")

      day = if String.length(day) == 1 do
        "0#{day}"
      else
        day
      end

      "#{month}/#{day}/#{year}"
    else
      date
    end
  end
end
