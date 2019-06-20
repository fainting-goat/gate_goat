defmodule GateGoat.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :description, :string
    field :duration, :integer
    field :name, :string
    field :owner, :string
    field :start_time, :naive_datetime
    field :replaced_by_id, :integer
    belongs_to :event, GateGoat.Events.Event

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:name, :start_time, :duration, :description, :owner, :event_id, :replaced_by_id])
    |> cast_assoc(:event, with: &GateGoat.Events.Event.changeset/2)
    |> validate_required([:name, :start_time, :duration, :description, :owner])
  end
end
