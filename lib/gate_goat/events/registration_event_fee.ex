defmodule GateGoat.Events.RegistrationEventFee do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Events.Registration
  alias GateGoat.Events.EventFee

  schema "registration_event_fees" do
    field :selected, :boolean, default: false

    belongs_to :registration, Registration
    belongs_to :event_fee, EventFee

    timestamps()
  end

  @doc false
  def changeset(registration_event_fee, attrs) do
    attrs = update_site_fee(attrs)
    registration_event_fee
    |> cast(attrs, [:selected, :event_fee_id, :registration_id])
    |> validate_required([:selected])
    |> create_event_fee_assoc(attrs)
  end

  def create_event_fee_assoc(registration_event_fee, %{"event_fee" => %{"id" => id}}) do
    registration_event_fee
    |> put_assoc(:event_fee, GateGoat.Events.get_event_fee!(id))
  end
  def create_event_fee_assoc(registration_event_fee, _) do
    registration_event_fee
  end

  defp update_site_fee(%{"event_fee" => %{"id" => id}} = attrs) do
    if GateGoat.Events.get_event_fee!(id).fee.name == "Site" do
      %{"event_fee" => %{"id" => id}, "selected" => "true"}
    else
      attrs
    end
  end
  defp update_site_fee(attrs), do: attrs
end
