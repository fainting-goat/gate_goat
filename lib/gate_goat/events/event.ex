defmodule GateGoat.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Events.Registration

  schema "events" do
    field :camping_fee, :integer
    field :event_date, :date
    field :event_fee, :integer
    field :event_name, :string
    field :feast_fee, :integer
    field :checks_payable, :string
    has_many :registration, Registration

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:event_name, :camping_fee, :event_fee, :feast_fee, :event_date, :checks_payable])
    |> validate_required([:event_name, :camping_fee, :event_fee, :feast_fee, :event_date, :checks_payable])
  end
end
