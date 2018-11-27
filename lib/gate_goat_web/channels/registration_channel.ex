defmodule GateGoatWeb.RegistrationChannel do
  use Phoenix.Channel
  alias Phoenix.HTML.FormData
  alias GateGoat.Events
  alias GateGoat.Events.Registration

  def join("registration", _message, socket) do
    {:ok, socket}
  end

  def handle_in("attendee_count", %{"num_of_attendees" => num_of_attendees, "event_id" => event_id}, socket) do
    IO.inspect Plug.CSRFProtection.get_csrf_token_for("/register/create")
    IO.inspect Plug.CSRFProtection.get_csrf_token_for("/register/new")
    IO.inspect Plug.CSRFProtection.get_csrf_token()
    changeset = Events.change_registration(%Registration{})

    f = changeset
      |> FormData.to_form([])

    IO.inspect f
    GateGoatWeb.RegistrationView
    |> Phoenix.View.render_to_string("workaround.html", num_of_attendees: num_of_attendees, event_id: event_id, changeset: changeset, f: f, conn: socket)
    |> push_html("attendee_response", socket)
  end

  defp push_html(html, channel, socket) do
    push(socket, channel, %{html: html})
    {:noreply, socket}
  end
end
