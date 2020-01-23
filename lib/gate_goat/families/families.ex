defmodule GateGoat.Families do

  alias GateGoat.Repo
  alias GateGoat.Families.Family

  def list_families do
    Repo.all(Family)
  end

  def get_family(id), do: Repo.get(Family, id)

  def create_family(attrs) do
    %Family{} |> Family.changeset(attrs) |> Repo.insert()
  end

  def update_family(%Family{} = family, attrs) do
    family |> Family.changeset(attrs) |> Repo.update()
  end

  def delete_family(%Family{} = family) do
    Repo.delete(family)
  end
end
