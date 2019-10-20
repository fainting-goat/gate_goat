defmodule GateGoat.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias GateGoat.Repo

  alias GateGoat.Activities.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Repo.all(from c in Activity, where: is_nil(c.replaced_by_id))
    |> Repo.preload(:event)
  end

  def list_activities_for_event(event_id) do
    Repo.all(from c in Activity, where: c.event_id == ^event_id and is_nil(c.replaced_by_id))
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id) do
    Repo.get!(Activity, id)
    |> Repo.preload(:event)
  end

  def get_activity_by_replacement(id) do
    Repo.one(from c in Activity, where: c.replaced_by_id == ^id)
  end

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    with {:ok, new_activity} <- create_activity(attrs),
         {:ok, activity} <- update_replaced_by_id(activity, new_activity)
    do
      {:ok, new_activity}
    else
      _ -> {:error, activity}
    end
  end

  def create_new_activity(attrs) do
    attrs
    |> Map.delete("event")
    |> create_activity()
    |> Repo.preload(:event)
  end

  def update_replaced_by_id(activity, new_activity) do
    activity
    |> Activity.changeset(%{replaced_by_id: new_activity.id})
    |> Repo.update()
  end

  @doc """
  Deletes a Activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    historical_activity = get_activity_by_replacement(activity.id)
    unless historical_activity == nil do
      delete_activity(historical_activity)
    end

    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{source: %Activity{}}

  """
  def change_activity(%Activity{} = activity) do
    Activity.changeset(activity, %{})
  end

  def updated_activities(activities) do
    Enum.reduce(activities, [], fn(x, acc) ->
      item = Repo.all(from c in Activity, where: c.replaced_by_id == ^x.id)
      acc ++ item
    end)
  end
end
