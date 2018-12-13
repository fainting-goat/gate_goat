defmodule GateGoat.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :type, :string

      timestamps()
    end

    alter table(:users) do
      add :role_id, references(:roles)
    end

  end
end
