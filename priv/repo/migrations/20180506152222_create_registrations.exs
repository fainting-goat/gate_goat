defmodule GateGoat.Repo.Migrations.CreateRegistrations do
  use Ecto.Migration

  def change do
    create table(:registrations) do
      add :sca_name, :string, null: false
      add :legal_name, :string, null: false
      add :membership_number, :string, null: false
      add :membership_expiration_date, :date, null: false
      add :group_name, :string, null: true
      add :waiver, :boolean, default: false, null: false
      add :feast_option, :boolean, default: false
      add :camping_option, :boolean, default: false

      timestamps()
    end
  end
end
