defmodule GateGoat.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias GateGoat.Repo
  alias GateGoat.Events.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
    |> Repo.preload([:event_fee, {:event_fee, :fee}])
  end

  def list_current_events(datetime_stub \\ DateTime) do
    Repo.all(from c in Event, where: c.event_date >= ^datetime_stub.utc_now())
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id) do
    Repo.get!(Event, id)
    |> Repo.preload([:event_fee, {:event_fee, :fee}])
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    attrs = Map.put(attrs, "event_date", GateGoat.Helpers.human_to_elixir_date(attrs["event_date"]))

    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, %{"event_date" => event_date} = attrs) do
    attrs = Map.put(attrs, "event_date", GateGoat.Helpers.human_to_elixir_date(event_date))
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  def new_event_with_fees() do
    all_fees = Enum.reduce(GateGoat.Fees.list_fees(), [], fn x, acc ->[%GateGoat.Events.EventFee{fee: x, amount: 0} | acc] end)
    Event.changeset(%Event{event_fee: all_fees}, %{})
  end
end
