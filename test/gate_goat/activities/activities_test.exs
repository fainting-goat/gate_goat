defmodule GateGoat.ActivitiesTest do
  use GateGoat.DataCase

  alias GateGoat.Activities

  describe "activities" do
    alias GateGoat.Activities.Activity

    @valid_attrs %{description: "some description", duration: 42, name: "some name", owner: "some owner", start_time: ~D[2010-04-17]}
    @update_attrs %{description: "some updated description", duration: 43, name: "some updated name", owner: "some updated owner", start_time: ~D[2011-05-18]}
    @invalid_attrs %{description: nil, duration: nil, name: nil, owner: nil, start_time: nil}

    def activity_fixture(attrs \\ %{}) do
      {:ok, activity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_activity()

      activity
    end

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      assert {:ok, %Activity{} = activity} = Activities.create_activity(@valid_attrs)
      assert activity.description == "some description"
      assert activity.duration == 42
      assert activity.name == "some name"
      assert activity.owner == "some owner"
      assert activity.start_time == ~D[2010-04-17]
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, @update_attrs)
      assert activity.description == "some updated description"
      assert activity.duration == 43
      assert activity.name == "some updated name"
      assert activity.owner == "some updated owner"
      assert activity.start_time == ~D[2011-05-18]
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end
end
