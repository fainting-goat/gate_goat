defmodule GateGoat.Repo.Migrations.RemoveFeeColumns do
  use Ecto.Migration

  def change do
    alter table(:registrations) do
      remove :lunch_option
      remove :feast_option
      remove :camping_option
    end

    alter table(:events) do
      remove :camping_fee
      remove :site_fee
      remove :feast_fee
      remove :lunch_fee
    end
  end
end
