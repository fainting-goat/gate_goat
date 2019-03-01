defmodule GateGoat.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Events.Registration
  alias GateGoat.Events.EventFee

  schema "events" do
    field :camping_fee, :decimal
    field :event_date, :date
    field :site_fee, :decimal
    field :event_name, :string
    field :feast_fee, :decimal
    field :lunch_fee, :decimal
    field :checks_payable, :string
    field :feast_available, :boolean, default: true
    has_many :registration, Registration
    has_many :event_fee, EventFee

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:event_name, :camping_fee, :site_fee, :feast_fee, :lunch_fee, :event_date, :checks_payable, :feast_available])
    |> validate_required([:event_name, :event_date, :checks_payable, :feast_available])
    |> cast_assoc(:event_fee, with: &GateGoat.Events.EventFee.changeset/2)
    |> validate_event_date(:event_date)
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
