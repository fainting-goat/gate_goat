defmodule GateGoatWeb.ActivityController do
  use GateGoatWeb, :controller

  alias GateGoat.Activities
  alias GateGoat.Activities.Activity

  def index(conn, %{"event_id" => event_id}) do
    activities = Activities.list_activities_for_event(event_id)

    conn
    |> render("index.html", activities: activities, event: GateGoat.Events.get_event!(event_id))
    end
  def index(conn, _params) do
    user = GateGoat.AdminHelper.current_user(conn)

    if user.role.type == "admin" do
      activities = Activities.list_activities()

      conn
      |> render("index_admin.html", activities: activities)
    else
      activities = Activities.list_activities_for_event(user.event.id)

      conn
      |> render("index.html", activities: activities, event: GateGoat.Events.get_event!(user.event.id))
    end
  end

  def new(conn, %{"event_id" => event_id}) do
    event = GateGoat.Events.get_event!(event_id)
    {:ok, date} = NaiveDateTime.new(event.event_date, ~T[00:00:00])

    changeset = Activities.change_activity(%Activity{event_id: event_id, start_time: date})
    render(conn, "new.html", changeset: changeset)
  end

  #this feels like cheating
  def create(conn, %{"action" => "filter", "event" => event_id}) do
    activities = Activities.list_activities_for_event(event_id)
                 |> GateGoat.Repo.preload(:event)

    conn
    |> render("index_admin.html", activities: activities)
  end
  def create(conn, %{"action" => "clear"}) do
    index(conn, nil)
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
