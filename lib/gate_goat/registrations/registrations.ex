defmodule GateGoat.Registrations do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias GateGoat.Repo
  alias GateGoat.Registrations.Registration

  @doc """
  Returns the list of registrations.

  ## Examples

      iex> list_registrations()
      [%Registration{}, ...]

  """
  def list_registrations(event_id) do
    Repo.all(from c in Registration, where: c.event_id == ^event_id)
    |> preload_event_data()
  end
  def list_registrations do
    Repo.all(Registration)
    |> preload_event_data()
  end

  def list_registrations_events do
    Repo.all(from r in Registration, order_by: r.id)
    |> preload_event_data()
  end

  def preload_event_data(dataset) do
    Repo.preload(dataset, [:registration_event_fee, {:event, [{:event_fee, :fee}]}])
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
    |> Repo.preload([:registration_event_fee, {:registration_event_fee, [{:event_fee, :fee}]}, {:event, [{:event_fee, :fee}]}])
  end
  def get_registration(id) do
    Repo.get(Registration, id)
    |> Repo.preload([:registration_event_fee, {:registration_event_fee, [{:event_fee, :fee}]}, {:event, [{:event_fee, :fee}]}])
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
    attrs = Map.put(attrs, "membership_expiration_date", GateGoat.Helpers.human_to_elixir_date(attrs["membership_expiration_date"]))

    %Registration{}
    |> Repo.preload(:event)
    |> Registration.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:event, GateGoat.Events.get_event!(event_id))
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
    attrs = Map.put(attrs, "membership_expiration_date", GateGoat.Helpers.human_to_elixir_date(attrs["membership_expiration_date"]))

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
    all_fees = Enum.reduce(GateGoat.Fees.list_fees_for_event(event_id), [], fn x, acc ->
      [%GateGoat.Registrations.RegistrationEventFee{event_fee: x} | acc]
    end)
    Registration.changeset(%Registration{registration_event_fee: all_fees}, %{})
  end
end
