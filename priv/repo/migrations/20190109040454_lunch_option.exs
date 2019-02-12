defmodule GateGoat.Repo.Migrations.LunchOption do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :lunch_fee, :decimal, default: 0
    end

    alter table(:registrations) do
      add :lunch_option, :boolean, default: false
    end
  end
end
