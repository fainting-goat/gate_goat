defmodule GateGoat.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Events.Registration

  schema "events" do
    field :camping_fee, :decimal
    field :event_date, :date
    field :event_fee, :decimal
    field :event_name, :string
    field :feast_fee, :decimal
    field :checks_payable, :string
    field :feast_available, :boolean, default: true
    has_many :registration, Registration

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:event_name, :camping_fee, :event_fee, :feast_fee, :event_date, :checks_payable, :feast_available])
    |> validate_required([:event_name, :camping_fee, :event_fee, :feast_fee, :event_date, :checks_payable, :feast_available])
    |> validate_fee(:event_fee)
    |> validate_fee(:camping_fee)
    |> validate_fee(:feast_fee)
    |> validate_event_date(:event_date)
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

  def validate_event_date(changeset, field) do
    validate_change(changeset, field, fn _, date ->
      case Date.compare(date, Date.utc_today()) do
        :lt ->  [{field, "This event occurs in the past."}]
        _ -> []
      end
    end)
  end
end
