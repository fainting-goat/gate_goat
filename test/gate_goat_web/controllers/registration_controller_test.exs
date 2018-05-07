defmodule GateGoatWeb.RegistrationControllerTest do
  use GateGoatWeb.ConnCase

  alias GateGoat.Events

  @create_attrs %{group_name: "some group_name", membership_number: "some membership_number", mundane_name: "some mundane_name", sca_name: "some sca_name", waiver: true}
  @update_attrs %{group_name: "some updated group_name", membership_number: "some updated membership_number", mundane_name: "some updated mundane_name", sca_name: "some updated sca_name", waiver: false}
  @invalid_attrs %{group_name: nil, membership_number: nil, mundane_name: nil, sca_name: nil, waiver: nil}

  def fixture(:registration) do
    {:ok, registration} = Events.create_registration(@create_attrs)
    registration
  end

  describe "index" do
    test "lists all registrations", %{conn: conn} do
      conn = get conn, registration_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Registrations"
    end
  end

  describe "new registration" do
    test "renders form", %{conn: conn} do
      conn = get conn, registration_path(conn, :new)
      assert html_response(conn, 200) =~ "New Registration"
    end
  end

  describe "create registration" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), registration: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == registration_path(conn, :show, id)

      conn = get conn, registration_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Registration"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), registration: @invalid_attrs
      assert html_response(conn, 200) =~ "New Registration"
    end
  end

  describe "edit registration" do
    setup [:create_registration]

    test "renders form for editing chosen registration", %{conn: conn, registration: registration} do
      conn = get conn, registration_path(conn, :edit, registration)
      assert html_response(conn, 200) =~ "Edit Registration"
    end
  end

  describe "update registration" do
    setup [:create_registration]

    test "redirects when data is valid", %{conn: conn, registration: registration} do
      conn = put conn, registration_path(conn, :update, registration), registration: @update_attrs
      assert redirected_to(conn) == registration_path(conn, :show, registration)

      conn = get conn, registration_path(conn, :show, registration)
      assert html_response(conn, 200) =~ "some updated group_name"
    end

    test "renders errors when data is invalid", %{conn: conn, registration: registration} do
      conn = put conn, registration_path(conn, :update, registration), registration: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Registration"
    end
  end

  describe "delete registration" do
    setup [:create_registration]

    test "deletes chosen registration", %{conn: conn, registration: registration} do
      conn = delete conn, registration_path(conn, :delete, registration)
      assert redirected_to(conn) == registration_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, registration_path(conn, :show, registration)
      end
    end
  end

  defp create_registration(_) do
    registration = fixture(:registration)
    {:ok, registration: registration}
  end
end
