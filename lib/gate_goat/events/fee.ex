defmodule GateGoat.Events.Fee do
  use Ecto.Schema
  import Ecto.Changeset


  schema "fees" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(fee, attrs) do
    fee
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
