defmodule GateGoat.Repo.Migrations.CreateFees do
  use Ecto.Migration

  def change do
    create table(:fees) do
      add :name, :string

      timestamps()
    end

    create table(:event_fees) do
      add :amount, :decimal
      add :fee_id, references(:fees)
      add :event_id, references(:events)

      timestamps()
    end

    create table(:registration_event_fees) do
      add :event_fee_id, references(:event_fees)
      add :registration_id, references(:registrations)

      timestamps()
    end

    rename table(:events), :event_fee, to: :site_fee
  end
end
