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

Repo.insert!(event_changeset1)
