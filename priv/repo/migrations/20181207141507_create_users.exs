defmodule GateGoat.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password_hash, :string
      add :password, :string
      add :event_id, references(:events)

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
