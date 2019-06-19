defmodule GateGoat.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :name, :string
      add :start_time, :naive_datetime
      add :duration, :integer
      add :description, :string
      add :owner, :string
      add :event_id, references(:events)

      timestamps()
    end

  end
end
