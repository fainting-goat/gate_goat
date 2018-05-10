import Ecto
import Ecto.Changeset
import Ecto.Query

alias GateGoat.Repo
alias GateGoat.Events.Event

event_changeset1 = Event.changeset(
  %Event{},
  %{
    event_name: "Red Dragon",
    event_date: ~D[2018-10-15],
    event_fee: 10,
    feast_fee: 10,
    camping_fee: 5
  }
)

event_changeset2 = Event.changeset(
  %Event{},
  %{
    event_name: "Coronation",
    event_date: ~D[2018-05-21],
    event_fee: 22,
    feast_fee: 12,
    camping_fee: 2
  }
)

Repo.insert!(event_changeset1)
Repo.insert!(event_changeset2)
