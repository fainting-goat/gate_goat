defmodule GateGoatWeb.ActivityController do
  use GateGoatWeb, :controller

  alias GateGoat.Activities
  alias GateGoat.Activities.Activity

  def index(conn, %{"event_id" => event_id}) do
    activities = Activities.list_activities_for_event(event_id)

    conn
    |> render("index.html", activities: activities)
    end
  def index(conn, _params) do
    activities = Activities.list_activities()

    conn
    |> render("index_admin.html", activities: activities)
  end

  def new(conn, _params) do
    changeset = Activities.change_activity(%Activity{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"activity" => activity_params}) do
    case Activities.create_activity(activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> redirect(to: Routes.activity_path(conn, :show, activity))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    activity = Activities.get_activity!(id)
    render(conn, "show.html", activity: activity)
  end

  def edit(conn, %{"id" => id}) do
    activity = Activities.get_activity!(id)
    changeset = Activities.change_activity(activity)
    render(conn, "edit.html", activity: activity, changeset: changeset)
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Activities.get_activity!(id)

    case Activities.update_activity(activity, activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: Routes.activity_path(conn, :show, activity))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", activity: activity, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity = Activities.get_activity!(id)
    {:ok, _activity} = Activities.delete_activity(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: Routes.activity_path(conn, :index))
  end
end
