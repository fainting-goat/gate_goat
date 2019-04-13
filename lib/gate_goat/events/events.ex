defmodule GateGoat.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias GateGoat.Repo
  alias GateGoat.Events.Registration

  @doc """
  Returns the list of registrations.

  ## Examples

      iex> list_registrations()
      [%Registration{}, ...]

  """
  def list_registrations(event_id) do
    Repo.all(from c in Registration, where: c.event_id == ^event_id)
  end
  def list_registrations do
    Repo.all(Registration)
    |> Repo.preload([:registration_event_fee, :event, {:event, :event_fee}, {:registration_event_fee, :fee}])
  end

  def list_registrations_events do
    Repo.all(from r in Registration, order_by: r.id)
    |> Repo.preload([:event, {:event, :event_fee}])
    |> Repo.preload([:registration_event_fee, {:registration_event_fee, [:event_fee, {:event_fee, :fee}]}])
  end

  @doc """
  Gets a single registration.

  Raises `Ecto.NoResultsError` if the Registration does not exist.

  ## Examples

      iex> get_registration!(123)
      %Registration{}

      iex> get_registration!(456)
      ** (Ecto.NoResultsError)

  """
  def get_registration!(id) do
    Repo.get!(Registration, id)
    |> Repo.preload([:event, {:event, :event_fee}])
    |> Repo.preload([:registration_event_fee, {:registration_event_fee, [:event_fee, {:event_fee, :fee}]}])
  end
  def get_registration(id) do
    Repo.get(Registration, id)
    |> Repo.preload([:event, {:event, :event_fee}])
    |> Repo.preload([:registration_event_fee, {:registration_event_fee, [:event_fee, {:event_fee, :fee}]}])
  end

  @doc """
  Creates a registration.

  ## Examples

      iex> create_registration(%{field: value})
      {:ok, %Registration{}}

      iex> create_registration(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_registration(attrs \\ %{}, event_id) do
    attrs = Map.put(attrs, "membership_expiration_date", human_to_elixir_date(attrs["membership_expiration_date"]))

    %Registration{}
    |> Repo.preload(:event)
    |> Registration.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:event, get_event!(event_id))
    |> Repo.insert()
  end

  @doc """
  Updates a registration.

  ## Examples

      iex> update_registration(registration, %{field: new_value})
      {:ok, %Registration{}}

      iex> update_registration(registration, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_registration(%Registration{} = registration, attrs) do
    registration
    |> Registration.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Registration.

  ## Examples

      iex> delete_registration(registration)
      {:ok, %Registration{}}

      iex> delete_registration(registration)
      {:error, %Ecto.Changeset{}}

  """
  def delete_registration(%Registration{} = registration) do
    Repo.delete(registration)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking registration changes.

  ## Examples

      iex> change_registration(registration)
      %Ecto.Changeset{source: %Registration{}}

  """
  def change_registration(%Registration{} = registration, params) do
    Registration.changeset(registration, params)
  end
    def change_registration(%Registration{} = registration) do
    Registration.changeset(registration, %{})
  end

  def new_registration_with_fees(event_id) do
    all_fees = Enum.reduce(list_fees_for_event(event_id), [], fn x, acc ->
      [%GateGoat.Events.RegistrationEventFee{event_fee: x} | acc]
    end)
    Registration.changeset(%Registration{registration_event_fee: all_fees}, %{})
  end

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

  def list_current_events do
    Repo.all(from c in Event, where: c.event_date >= ^DateTime.utc_now())
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
    attrs = Map.put(attrs, "event_date", human_to_elixir_date(attrs["event_date"]))

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
    attrs = Map.put(attrs, "event_date", human_to_elixir_date(event_date))
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
    all_fees = Enum.reduce(list_fees(), [], fn x, acc ->[%GateGoat.Events.EventFee{fee: x, amount: 0} | acc] end)
    Event.changeset(%Event{event_fee: all_fees}, %{})
  end

  def human_to_elixir_date(date) do
    if date =~ "/" do
      [month, day, year] = String.split(date, "/")

      day = if String.length(day) == 1 do
        "0#{day}"
      else
        day
      end

      "#{year}-#{month}-#{day}"
    else
      date
    end
  end

  def elixir_to_human_date(date) do
    date = Date.to_string(date)

    if String.match?(date, ~r/\d\d\d\d\-\d\d\-\d\d/) do
      [year, month, day] = String.split(date, "-")

      day = if String.length(day) == 1 do
        "0#{day}"
      else
        day
      end

      "#{month}/#{day}/#{year}"
    else
      date
    end
  end

  alias GateGoat.Events.Fee

  @doc """
  Returns the list of fees.

  ## Examples

      iex> list_fees()
      [%Fee{}, ...]

  """
  def list_fees do
    Repo.all(Fee)
  end

  @doc """
  Gets a single fee.

  Raises `Ecto.NoResultsError` if the Fee does not exist.

  ## Examples

      iex> get_fee!(123)
      %Fee{}

      iex> get_fee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fee!(id), do: Repo.get!(Fee, id)

  @doc """
  Creates a fee.

  ## Examples

      iex> create_fee(%{field: value})
      {:ok, %Fee{}}

      iex> create_fee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fee(attrs \\ %{}) do
    %Fee{}
    |> Fee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fee.

  ## Examples

      iex> update_fee(fee, %{field: new_value})
      {:ok, %Fee{}}

      iex> update_fee(fee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fee(%Fee{} = fee, attrs) do
    fee
    |> Fee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Fee.

  ## Examples

      iex> delete_fee(fee)
      {:ok, %Fee{}}

      iex> delete_fee(fee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fee(%Fee{} = fee) do
    Repo.delete(fee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fee changes.

  ## Examples

      iex> change_fee(fee)
      %Ecto.Changeset{source: %Fee{}}

  """
  def change_fee(%Fee{} = fee) do
    Fee.changeset(fee, %{})
  end

  def list_fees_for_event(event_id) do
    Repo.all(from c in GateGoat.Events.EventFee, where: c.event_id == ^event_id)
    |> Repo.preload(:fee)
  end

  def get_event_fee!(id) do
    Repo.get!(GateGoat.Events.EventFee, id)
    |> Repo.preload(:fee)
  end
end
