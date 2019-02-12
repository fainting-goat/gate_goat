import Ecto.Query

alias GateGoat.Repo
alias GateGoat.Events
alias GateGoat.Events.Fee
alias GateGoat.Events.EventFee
alias GateGoat.Events.RegistrationEventFee

Repo.delete_all(EventFee)
Repo.delete_all(Fee)

{:ok, feast_fee} = Events.create_fee(%{name: "Feast Fee"})
{:ok, lunch_fee} = Events.create_fee(%{name: "Lunch Fee"})
{:ok, site_fee} = Events.create_fee(%{name: "Site Fee"})
{:ok, camping_fee} = Events.create_fee(%{name: "Camping Fee"})

current_events = Events.list_events()

Enum.each(current_events, fn(event) ->
  Repo.insert!(%EventFee{amount: event.feast_fee, fee_id: feast_fee.id, event_id: event.id})
  Repo.insert!(%EventFee{amount: event.lunch_fee, fee_id: lunch_fee.id,  event_id: event.id})
  Repo.insert!(%EventFee{amount: event.site_fee, fee_id: site_fee.id,  event_id: event.id})
  Repo.insert!(%EventFee{amount: event.camping_fee, fee_id: camping_fee.id,  event_id: event.id})
end)

current_registrations = Events.list_registrations()

Enum.each(current_registrations, fn(person) ->
  site_fee_id = from(e in EventFee, where: e.fee_id == ^site_fee.id and e.event_id == ^person.event_id)
                 |> Repo.one
  feast_fee_id = from(e in EventFee, where: e.fee_id == ^feast_fee.id and e.event_id == ^person.event_id)
                |> Repo.one
  lunch_fee_id = from(e in EventFee, where: e.fee_id == ^lunch_fee.id and e.event_id == ^person.event_id)
                |> Repo.one

  if person.feast_option do
    Repo.insert!(%RegistrationEventFee{registration_id: person.id, event_fee_id: feast_fee_id.id})
  end
  if person.lunch_option do
    Repo.insert!(%RegistrationEventFee{registration_id: person.id, event_fee_id: lunch_fee_id.id})
  end

  Repo.insert!(%RegistrationEventFee{registration_id: person.id, event_fee_id: site_fee_id.id})
end)
