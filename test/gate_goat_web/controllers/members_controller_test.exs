defmodule GateGoatWeb.MembersControllerTest do
  use GateGoatWeb.ConnCase

  alias GateGoat.Events

  @create_attrs %{group_name: "some group_name", membership_number: "some membership_number", legal_name: "some legal_name", sca_name: "some sca_name", waiver: true}
  @update_attrs %{group_name: "some updated group_name", membership_number: "some updated membership_number", legal_name: "some updated legal_name", sca_name: "some updated sca_name", waiver: false}
  @invalid_attrs %{group_name: nil, membership_number: nil, legal_name: nil, sca_name: nil, waiver: nil}

  def fixture(:members) do
    {:ok, members} = Events.create_members(@create_attrs)
    members
  end

  describe "index" do
    test "lists all registrations", %{conn: conn} do
      conn = get conn, members_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Registrations"
    end
  end

  describe "new members" do
    test "renders form", %{conn: conn} do
      conn = get conn, members_path(conn, :new)
      assert html_response(conn, 200) =~ "New Members"
    end
  end

  describe "create members" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, members_path(conn, :create), members: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == members_path(conn, :show, id)

      conn = get conn, members_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Members"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, members_path(conn, :create), members: @invalid_attrs
      assert html_response(conn, 200) =~ "New Members"
    end
  end

  describe "edit members" do
    setup [:create_members]

    test "renders form for editing chosen members", %{conn: conn, members: members} do
      conn = get conn, members_path(conn, :edit, members)
      assert html_response(conn, 200) =~ "Edit Members"
    end
  end

  describe "update members" do
    setup [:create_members]

    test "redirects when data is valid", %{conn: conn, members: members} do
      conn = put conn, members_path(conn, :update, members), members: @update_attrs
      assert redirected_to(conn) == members_path(conn, :show, members)

      conn = get conn, members_path(conn, :show, members)
      assert html_response(conn, 200) =~ "some updated group_name"
    end

    test "renders errors when data is invalid", %{conn: conn, members: members} do
      conn = put conn, members_path(conn, :update, members), members: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Members"
    end
  end

  describe "delete members" do
    setup [:create_members]

    test "deletes chosen members", %{conn: conn, members: members} do
      conn = delete conn, members_path(conn, :delete, members)
      assert redirected_to(conn) == members_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, members_path(conn, :show, members)
      end
    end
  end

  defp create_members(_) do
    members = fixture(:members)
    {:ok, members: members}
  end
end
