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
    |> validate_fee(:amount)
    |> create_fee_assoc(attrs)
    |> validate_required([:amount])
  end

  def create_fee_assoc(event_fee, %{"fee" => %{"id" => id}}) do
    event_fee
    |> put_assoc(:fee, GateGoat.Events.get_fee!(id))
  end
  def create_fee_assoc(event_fee, _) do
    event_fee
  end

  def validate_fee(changeset, field) do
    validate_change(changeset, field, fn _, fee ->
      if Regex.match?(~r/^\d+\.?[\d]?[\d]?$/, to_string(fee)) do
        []
      else
        [{field, "Fee is in an invalid format."}]
      end
    end)
  end
end
