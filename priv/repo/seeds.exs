alias GateGoat.Repo
alias GateGoat.Events.Event

event_changeset1 = Event.changeset(
  %Event{},
  %{
    event_name: "Yule Feast",
    event_date: ~D[2018-12-08],
    event_fee: 10,
    feast_fee: 10,
    camping_fee: 0,
    checks_payable: "SCA - Barony of Red Spears",
    feast_available: true
  }
)

event_changeset2 = Event.changeset(
  %Event{},
  %{
    event_name: "Demo Event",
    event_date: ~D[2020-12-20],
    event_fee: 10,
    feast_fee: 8,
    camping_fee: 5,
    checks_payable: "Demo Event",
    feast_available: true
  }
)

Repo.insert!(event_changeset1)
Repo.insert!(event_changeset2)
