defmodule GateGoat.RegistrationsTest do
  use GateGoat.DataCase

  alias GateGoat.Registrations

  describe "registrations" do
    alias GateGoat.Registrations.Registration

    @valid_attrs %{"group_name" => "some group_name", "membership_number" => "1234", "membership_expiration_date" => "12/20/2099", "legal_name" => "some legal_name", "sca_name" => "some sca_name", "waiver" => true}
    @update_attrs %{"group_name" => "some updated group_name", "membership_number" => "5678", "membership_expiration_date" => "10/20/2099", "legal_name" => "some updated legal_name", "sca_name" => "some updated sca_name", "waiver" => true}
    @invalid_attrs %{"group_name" => nil, "membership_number" => nil, "membership_expiration_date" => "12/20/2099", "legal_name" => nil, "sca_name" => nil, "waiver" => nil}
    @event_attrs %{"event_date" => "12/12/2099", "event_name" => "some event_name", "checks_payable" => "test"}

    def registration_fixture(attrs \\ %{}) do
      {:ok, event} = GateGoat.Events.create_event(@event_attrs)

      attrs
      |> Enum.into(@valid_attrs)
      |> Registrations.create_registration(event.id)
      |> elem(1)
      |> Repo.preload([:registration_event_fee])
    end

    test "list_registrations/0 returns all registrations" do
      registration = registration_fixture()
      assert Enum.member?(Registrations.list_registrations(), registration)
    end

    test "get_registration!/1 returns the registration with given id" do
      registration = registration_fixture()
      assert Registrations.get_registration!(registration.id) == registration
    end

    test "create_registration/1 with valid data creates a registration" do
      {:ok, event} = GateGoat.Events.create_event(@event_attrs)

      assert {:ok, %Registration{} = registration} = Registrations.create_registration(@valid_attrs, event.id)
      assert registration.group_name == "some group_name"
      assert registration.membership_number == "1234"
      assert registration.legal_name == "some legal_name"
      assert registration.sca_name == "some sca_name"
      assert registration.waiver == true
    end

    test "create_registration/1 with invalid data returns error changeset" do
      {:ok, event} = GateGoat.Events.create_event(@event_attrs)

      assert {:error, %Ecto.Changeset{}} = Registrations.create_registration(@invalid_attrs, event.id)
    end

    test "update_registration/2 with valid data updates the registration" do
      registration = registration_fixture()
      assert {:ok, registration} = Registrations.update_registration(registration, @update_attrs)
      assert %Registration{} = registration
      assert registration.group_name == "some updated group_name"
      assert registration.membership_number == "5678"
      assert registration.legal_name == "some updated legal_name"
      assert registration.sca_name == "some updated sca_name"
      assert registration.waiver == true
    end

    test "update_registration/2 with invalid data returns error changeset" do
      registration = registration_fixture()
      assert {:error, %Ecto.Changeset{}} = Registrations.update_registration(registration, @invalid_attrs)
      assert registration == Registrations.get_registration!(registration.id)
    end

    test "delete_registration/1 deletes the registration" do
      registration = registration_fixture()
      assert {:ok, %Registration{}} = Registrations.delete_registration(registration)
      assert_raise Ecto.NoResultsError, fn -> Registrations.get_registration!(registration.id) end
    end

    test "change_registration/1 returns a registration changeset" do
      registration = registration_fixture()
      assert %Ecto.Changeset{} = Registrations.change_registration(registration)
    end
  end
end
