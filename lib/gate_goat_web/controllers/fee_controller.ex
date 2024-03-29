defmodule GateGoatWeb.FeeController do
  use GateGoatWeb, :controller

  alias GateGoat.Fees
  alias GateGoat.Fees.Fee

  def index(conn, _params) do
    fees = Fees.list_fees()
    render(conn, "index.html", fees: fees)
  end

  def new(conn, _params) do
    changeset = Fees.change_fee(%Fee{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"fee" => fee_params}) do
    case Fees.create_fee(fee_params) do
      {:ok, fee} ->
        conn
        |> put_flash(:info, "Fee created successfully.")
        |> redirect(to: Routes.fee_path(conn, :show, fee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fee = Fees.get_fee!(id)
    render(conn, "show.html", fee: fee)
  end

  def edit(conn, %{"id" => id}) do
    fee = Fees.get_fee!(id)
    changeset = Fees.change_fee(fee)
    render(conn, "edit.html", fee: fee, changeset: changeset)
  end

  def update(conn, %{"id" => id, "fee" => fee_params}) do
    fee = Fees.get_fee!(id)

    case Fees.update_fee(fee, fee_params) do
      {:ok, fee} ->
        conn
        |> put_flash(:info, "Fee updated successfully.")
        |> redirect(to: Routes.fee_path(conn, :show, fee))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", fee: fee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fee = Fees.get_fee!(id)
    {:ok, _fee} = Fees.delete_fee(fee)

    conn
    |> put_flash(:info, "Fee deleted successfully.")
    |> redirect(to: Routes.fee_path(conn, :index))
  end
end
