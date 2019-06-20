defmodule GateGoat.Repo.Migrations.AddSoftDelete do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :replaced_by_id, :integer
    end
  end
end
