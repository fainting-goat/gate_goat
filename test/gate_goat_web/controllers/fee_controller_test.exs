defmodule GateGoatWeb.FeeControllerTest do
  use GateGoatWeb.ConnCase

  alias GateGoat.Events

  @create_attrs %{amount: "120.5", name: "some name"}
  @update_attrs %{amount: "456.7", name: "some updated name"}
  @invalid_attrs %{amount: nil, name: nil}

  def fixture(:fee) do
    {:ok, fee} = Events.create_fee(@create_attrs)
    fee
  end

  describe "index" do
    test "lists all fees", %{conn: conn} do
      conn = get(conn, Routes.fee_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Fees"
    end
  end

  describe "new fee" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.fee_path(conn, :new))
      assert html_response(conn, 200) =~ "New Fee"
    end
  end

  describe "create fee" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.fee_path(conn, :create), fee: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.fee_path(conn, :show, id)

      conn = get(conn, Routes.fee_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Fee"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.fee_path(conn, :create), fee: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Fee"
    end
  end

  describe "edit fee" do
    setup [:create_fee]

    test "renders form for editing chosen fee", %{conn: conn, fee: fee} do
      conn = get(conn, Routes.fee_path(conn, :edit, fee))
      assert html_response(conn, 200) =~ "Edit Fee"
    end
  end

  describe "update fee" do
    setup [:create_fee]

    test "redirects when data is valid", %{conn: conn, fee: fee} do
      conn = put(conn, Routes.fee_path(conn, :update, fee), fee: @update_attrs)
      assert redirected_to(conn) == Routes.fee_path(conn, :show, fee)

      conn = get(conn, Routes.fee_path(conn, :show, fee))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, fee: fee} do
      conn = put(conn, Routes.fee_path(conn, :update, fee), fee: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Fee"
    end
  end

  describe "delete fee" do
    setup [:create_fee]

    test "deletes chosen fee", %{conn: conn, fee: fee} do
      conn = delete(conn, Routes.fee_path(conn, :delete, fee))
      assert redirected_to(conn) == Routes.fee_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.fee_path(conn, :show, fee))
      end
    end
  end

  defp create_fee(_) do
    fee = fixture(:fee)
    {:ok, fee: fee}
  end
end
