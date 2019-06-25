defmodule GateGoatWeb.RegistrationControllerTest do
  use GateGoatWeb.ConnCase

  alias GateGoat.Registrations

#  @create_attrs %{group_name: "some group_name", membership_number: "1234", membership_expiration_date: "12/20/2099", legal_name: "some legal_name", sca_name: "some sca_name", waiver: true}
#  @update_attrs %{group_name: "some updated group_name", membership_number: "5678", membership_expiration_date: "12/10/2099", legal_name: "some updated legal_name", sca_name: "some updated sca_name", waiver: false}
#  @invalid_attrs %{group_name: nil, membership_number: nil, legal_name: nil, sca_name: nil, waiver: nil}

  @create_attrs %{"group_name" => "some group_name", "membership_number" => "1234", "membership_expiration_date" => "12/20/2099", "legal_name" => "some legal_name", "sca_name" => "some sca_name", "waiver" => true}
  @update_attrs %{"group_name" => "some updated group_name", "membership_number" => "5678", "membership_expiration_date" => "10/20/2099", "legal_name" => "some updated legal_name", "sca_name" => "some updated sca_name", "waiver" => true}
  @invalid_attrs %{"group_name" => nil, "membership_number" => nil, "membership_expiration_date" => "12/20/2099", "legal_name" => nil, "sca_name" => nil, "waiver" => nil}
  @event_attrs %{"event_date" => "12/12/2099", "event_name" => "some event_name", "checks_payable" => "test"}


  def fixture(:registration) do
    {:ok, event} = GateGoat.Events.create_event(@event_attrs)

    {:ok, registration} = Registrations.create_registration(@create_attrs, event.id)
    registration
  end

#  describe "index" do
#    test "lists all registrations", %{conn: conn} do
#      conn = get conn, registration_path(conn, :index)
#      assert html_response(conn, 200) =~ "Listing Registrations"
#    end
#  end

  describe "new registration" do
    test "renders form", %{conn: conn} do
      {:ok, event} = GateGoat.Events.create_event(@event_attrs)

      conn = get conn, registration_path(conn, :new, event_id: event.id)
      assert html_response(conn, 200) =~ "New Registration"
    end
  end

  describe "create registration" do
    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, event} = GateGoat.Events.create_event(@event_attrs)

      conn = post conn, registration_path(conn, :create, event_id: event.id), registration: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == registration_path(conn, :show, id, event_id: event.id)

      conn = get conn, registration_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Registration created successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, event} = GateGoat.Events.create_event(@event_attrs)

      conn = post conn, registration_path(conn, :create, event_id: event.id), registration: @invalid_attrs
      assert html_response(conn, 200) =~ "New Registration"
    end
  end

#  describe "edit registration" do
#    setup [:create_registration]
#
#    test "renders form for editing chosen registration", %{conn: conn, registration: registration} do
#      conn = get conn, registration_path(conn, :edit, registration)
#      assert html_response(conn, 200) =~ "Edit Registration"
#    end
#  end

#  describe "update registration" do
#    setup [:create_registration]
#
#    test "redirects when data is valid", %{conn: conn, registration: registration} do
#      conn = put conn, registration_path(conn, :update, registration), registration: @update_attrs
#      assert redirected_to(conn) == registration_path(conn, :show, registration)
#
#      conn = get conn, registration_path(conn, :show, registration)
#      assert html_response(conn, 200) =~ "some updated group_name"
#    end
#
#    test "renders errors when data is invalid", %{conn: conn, registration: registration} do
#      conn = put conn, registration_path(conn, :update, registration), registration: @invalid_attrs
#      assert html_response(conn, 200) =~ "Edit Registration"
#    end
#  end

#  describe "delete registration" do
#    setup [:create_registration]
#
#    test "deletes chosen registration", %{conn: conn, registration: registration} do
#      conn = delete conn, registration_path(conn, :delete, registration)
#      assert redirected_to(conn) == registration_path(conn, :index)
#      assert_error_sent 404, fn ->
#        get conn, registration_path(conn, :show, registration)
#      end
#    end
#  end

  defp create_registration(_) do
    registration = fixture(:registration)
    {:ok, registration: registration}
  end
end
