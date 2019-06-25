defmodule GateGoat.EventsTest do
  use GateGoat.DataCase

  import Double

  alias GateGoat.Events

  describe "events" do
    alias GateGoat.Events.Event

    @valid_attrs %{"event_date" => "12/12/2099", "event_name" => "some event_name", "checks_payable" => "test"}
    @update_attrs %{"event_date" => "02/11/2099", "event_name" => "some other name", "checks_payable" => "other thing"}
    @invalid_attrs %{"event_date" => "02/11/2099", "event_name" => nil, "checks_payable" => nil}
    @valid_attrs_with_fee %{"event_date" => "12/12/2099",
      "event_name" => "some event_name",
      "checks_payable" => "test",
      "event_fee" => %{"0" => %{"amount" => "10", "fee" => %{"id" => "1"}}}}

    def event_fixture(attrs \\ %{}) do
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()
        |> elem(1)
        |> GateGoat.Repo.preload(:event_fee)
    end

    def event_with_fees_fixture(_attrs \\ %{}) do
      {:ok, fee} = GateGoat.Fees.create_fee(%{name: "Test Fee"})

      %{"event_fee" => %{"0" => %{"amount" => "10", "fee" => %{"id" => fee.id}}}}
      |> Enum.into(@valid_attrs_with_fee)
      |> Events.create_event()
      |> elem(1)
      |> GateGoat.Repo.preload(:event_fee)
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Enum.member?(Events.list_events(), event)
    end

    test "list_current_events/0 returns all events past today's date" do
      datetime_stub = stub(DateTime, :utc_now, fn() ->
        {:ok, date, _} =DateTime.from_iso8601("2100-01-23T23:50:07Z")
        date
      end)

      event = event_fixture()
      assert !Enum.member?(Events.list_current_events(datetime_stub), event)
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.event_date == ~D[2099-12-12]
      assert event.event_name == "some event_name"
      assert event.checks_payable == "test"
    end

    test "create_event/1 with valid data and fees creates a event" do
      {:ok, fee} = GateGoat.Fees.create_fee(%{name: "Test Fee"})

      attrs = %{"event_fee" => %{"0" => %{"amount" => "10", "fee" => %{"id" => fee.id}}}}
      |> Enum.into(@valid_attrs_with_fee)

      assert {:ok, %Event{} = event} = Events.create_event(attrs)
      assert event.event_date == ~D[2099-12-12]
      assert event.event_name == "some event_name"
      assert event.checks_payable == "test"

      event_fee = List.first(event.event_fee)
      assert event_fee.fee_id == fee.id
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Events.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.event_date == ~D[2099-02-11]
      assert event.event_name == "some other name"
      assert event.checks_payable == "other thing"
    end

    test "update_event/2 with valid data updates the fees" do
      event = event_with_fees_fixture()
      event_fee = event.event_fee
      |> List.first

      attrs = %{"event_fee" => %{"0" => %{"amount" => "20", "fee" => %{"id" => event_fee.fee_id}, "id" => event_fee.id}}}
      |> Enum.into(@update_attrs)

      assert {:ok, event} = Events.update_event(event, attrs)
      assert %Event{} = event
      assert event.event_date == ~D[2099-02-11]
      assert event.event_name == "some other name"
      assert event.checks_payable == "other thing"

      event_fee = List.first(event.event_fee)
      assert event_fee.amount == Decimal.new("20")
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

    test "new_event_with_fees/1 creates an empty changeset with fees loaded" do
      event = Events.new_event_with_fees()
      assert length(event.data.event_fee) == length(GateGoat.Fees.list_fees())
    end
  end
end
