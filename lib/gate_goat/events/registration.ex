defmodule GateGoat.Events.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Events.Event

  schema "registrations" do
    field :group_name, :string
    field :membership_number, :string
    field :mundane_name, :string
    field :sca_name, :string
    field :waiver, :boolean, default: false
    field :feast_option, :boolean, default: false
    field :camping_option, :boolean, default: false
    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:sca_name, :mundane_name, :membership_number, :group_name, :waiver, :feast_option, :camping_option])
    |> validate_required([:sca_name, :mundane_name, :membership_number, :group_name, :waiver, :feast_option, :camping_option])
    |> validate_format(:membership_number, ~r/^\d+$/, [message: "Membership number must be a number."])
  end
end
