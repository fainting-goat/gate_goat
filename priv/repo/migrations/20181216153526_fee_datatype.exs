defmodule GateGoat.Repo.Migrations.FeeDatatype do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :event_fee, :decimal
      modify :camping_fee, :decimal
      modify :feast_fee, :decimal
    end
  end
end
