defmodule GateGoat.Events.EventFee do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Events.Event
  alias GateGoat.Events.Fee

  schema "event_fees" do
    field :amount, :decimal

    belongs_to :event, Event
    belongs_to :fee, Fee

    timestamps()
  end

  @doc false
  def changeset(event_fee, attrs) do
    event_fee
    |> cast(attrs, [:amount, :fee_id, :event_id])
    |> cast_assoc(:fee)
    |> validate_required([:amount])
  end
end
