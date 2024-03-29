defmodule GateGoat.Fees do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias GateGoat.Repo
  alias GateGoat.Fees.Fee

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
