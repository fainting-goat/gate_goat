defmodule GateGoat.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event_name, :string
      add :camping_fee, :integer
      add :event_fee, :integer
      add :feast_fee, :integer
      add :event_date, :date
      add :checks_payable, :string

      timestamps()
    end

    alter table(:registrations) do
      add :event_id, references(:events)
    end
  end
end
