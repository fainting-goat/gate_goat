defmodule GateGoat.Families.Family do
  use Ecto.Schema
  import Ecto.Changeset
  alias GateGoat.Registrations.Registration

  schema "families" do
    field(:paying_famliy_member, :string)
    field(:size, :integer)
    field(:unrelated_minor, :boolean, default: false)
    has_many(:registrations, Registration)
    timestamps()
  end

  def changeset(family, attrs) do
    family
    |> cast(attrs, [:paying_family_member, :size, :unrelated_minor])
    |> validate_required([:paying_family_member, :size])
  end
end
