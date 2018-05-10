defmodule GateGoat.EventsTest do
  use GateGoat.DataCase

  alias GateGoat.Events

  describe "registrations" do
    alias GateGoat.Events.Members

    @valid_attrs %{group_name: "some group_name", membership_number: "some membership_number", mundane_name: "some mundane_name", sca_name: "some sca_name", waiver: true}
    @update_attrs %{group_name: "some updated group_name", membership_number: "some updated membership_number", mundane_name: "some updated mundane_name", sca_name: "some updated sca_name", waiver: false}
    @invalid_attrs %{group_name: nil, membership_number: nil, mundane_name: nil, sca_name: nil, waiver: nil}

    def members_fixture(attrs \\ %{}) do
      {:ok, members} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_members()

      members
    end

    test "list_registrations/0 returns all registrations" do
      members = members_fixture()
      assert Events.list_registrations() == [members]
    end

    test "get_members!/1 returns the members with given id" do
      members = members_fixture()
      assert Events.get_members!(members.id) == members
    end

    test "create_members/1 with valid data creates a members" do
      assert {:ok, %Members{} = members} = Events.create_members(@valid_attrs)
      assert members.group_name == "some group_name"
      assert members.membership_number == "some membership_number"
      assert members.mundane_name == "some mundane_name"
      assert members.sca_name == "some sca_name"
      assert members.waiver == true
    end

    test "create_members/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_members(@invalid_attrs)
    end

    test "update_members/2 with valid data updates the members" do
      members = members_fixture()
      assert {:ok, members} = Events.update_members(members, @update_attrs)
      assert %Members{} = members
      assert members.group_name == "some updated group_name"
      assert members.membership_number == "some updated membership_number"
      assert members.mundane_name == "some updated mundane_name"
      assert members.sca_name == "some updated sca_name"
      assert members.waiver == false
    end

    test "update_members/2 with invalid data returns error changeset" do
      members = members_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_members(members, @invalid_attrs)
      assert members == Events.get_members!(members.id)
    end

    test "delete_members/1 deletes the members" do
      members = members_fixture()
      assert {:ok, %Members{}} = Events.delete_members(members)
      assert_raise Ecto.NoResultsError, fn -> Events.get_members!(members.id) end
    end

    test "change_members/1 returns a members changeset" do
      members = members_fixture()
      assert %Ecto.Changeset{} = Events.change_members(members)
    end
  end

  describe "registrations" do
    alias GateGoat.Events.Registration

    @valid_attrs %{group_name: "some group_name", membership_number: "some membership_number", mundane_name: "some mundane_name", sca_name: "some sca_name", waiver: true}
    @update_attrs %{group_name: "some updated group_name", membership_number: "some updated membership_number", mundane_name: "some updated mundane_name", sca_name: "some updated sca_name", waiver: false}
    @invalid_attrs %{group_name: nil, membership_number: nil, mundane_name: nil, sca_name: nil, waiver: nil}

    def registration_fixture(attrs \\ %{}) do
      {:ok, registration} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_registration()

      registration
    end

    test "list_registrations/0 returns all registrations" do
      registration = registration_fixture()
      assert Events.list_registrations() == [registration]
    end

    test "get_registration!/1 returns the registration with given id" do
      registration = registration_fixture()
      assert Events.get_registration!(registration.id) == registration
    end

    test "create_registration/1 with valid data creates a registration" do
      assert {:ok, %Registration{} = registration} = Events.create_registration(@valid_attrs)
      assert registration.group_name == "some group_name"
      assert registration.membership_number == "some membership_number"
      assert registration.mundane_name == "some mundane_name"
      assert registration.sca_name == "some sca_name"
      assert registration.waiver == true
    end

    test "create_registration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_registration(@invalid_attrs)
    end

    test "update_registration/2 with valid data updates the registration" do
      registration = registration_fixture()
      assert {:ok, registration} = Events.update_registration(registration, @update_attrs)
      assert %Registration{} = registration
      assert registration.group_name == "some updated group_name"
      assert registration.membership_number == "some updated membership_number"
      assert registration.mundane_name == "some updated mundane_name"
      assert registration.sca_name == "some updated sca_name"
      assert registration.waiver == false
    end

    test "update_registration/2 with invalid data returns error changeset" do
      registration = registration_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_registration(registration, @invalid_attrs)
      assert registration == Events.get_registration!(registration.id)
    end

    test "delete_registration/1 deletes the registration" do
      registration = registration_fixture()
      assert {:ok, %Registration{}} = Events.delete_registration(registration)
      assert_raise Ecto.NoResultsError, fn -> Events.get_registration!(registration.id) end
    end

    test "change_registration/1 returns a registration changeset" do
      registration = registration_fixture()
      assert %Ecto.Changeset{} = Events.change_registration(registration)
    end
  end

  describe "events" do
    alias GateGoat.Events.Event

    @valid_attrs %{camping_fee: 42, event_date: ~D[2010-04-17], event_fee: 42, event_name: "some event_name", feast_fee: 42}
    @update_attrs %{camping_fee: 43, event_date: ~D[2011-05-18], event_fee: 43, event_name: "some updated event_name", feast_fee: 43}
    @invalid_attrs %{camping_fee: nil, event_date: nil, event_fee: nil, event_name: nil, feast_fee: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.camping_fee == 42
      assert event.event_date == ~D[2010-04-17]
      assert event.event_fee == 42
      assert event.event_name == "some event_name"
      assert event.feast_fee == 42
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Events.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.camping_fee == 43
      assert event.event_date == ~D[2011-05-18]
      assert event.event_fee == 43
      assert event.event_name == "some updated event_name"
      assert event.feast_fee == 43
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
