defmodule GateGoat.Events.RegistrationEventFee do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Events.Registration
  alias GateGoat.Events.EventFee

  schema "registration_event_fees" do
    belongs_to :registration, Registration
    belongs_to :event_fee, EventFee

    timestamps()
  end

  @doc false
  def changeset(registration_fee, attrs) do
    registration_fee
  end
end
