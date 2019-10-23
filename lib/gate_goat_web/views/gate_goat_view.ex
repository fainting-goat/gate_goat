defmodule GateGoatWeb.GateGoatView do
  use GateGoatWeb, :view

  def assign_event(conn, event_id) do
    conn
    |> Plug.Conn.put_session(:event, event_id)
  end

  def site_fee_verbiage("Site", fee) do
    non_discount_site = Decimal.add(Decimal.new(5), fee)
    "Site: $#{non_discount_site} - with member discount: $#{fee}"
  end
  def site_fee_verbiage(name, fee), do: "#{name}: $#{fee}"
end
