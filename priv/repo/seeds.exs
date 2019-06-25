alias GateGoat.Repo
alias GateGoat.Events.Event
alias GateGoat.Users.User
alias GateGoat.Users.Role
alias GateGoat.Fees.Fee
alias GateGoat.Events.EventFee
alias GateGoat.Registrations.RegistrationEventFee
alias GateGoat.Activities

admin_role_changest = Role.changeset(
  %Role{},
  %{
    type: "admin"
  }
)

user_role_changeset = Role.changeset(
  %Role{},
  %{
    type: "user"
  }
)

admin_role = Repo.insert!(admin_role_changest)
user_role = Repo.insert!(user_role_changeset)

admin_changeset = User.changeset(
  %User{},
  %{
    username: "admin",
    password: "adminadmin"
  }
)

user_changeset = User.changeset(
  %User{},
  %{
    username: "user",
    password: "useruser"
  }
)

admin = Repo.insert!(admin_changeset) |> Repo.preload(:role)
user = Repo.insert!(user_changeset) |> Repo.preload(:role)

admin_change = Ecto.Changeset.change(admin)
admin_change = Ecto.Changeset.put_assoc(admin_change, :role, admin_role)
Repo.update!(admin_change)

user_change = Ecto.Changeset.change(user)
user_change = Ecto.Changeset.put_assoc(user_change, :role, user_role)
Repo.update!(user_change)

{:ok, feast_fee} = GateGoat.Fees.create_fee(%{name: "Feast"})
{:ok, site_fee} =  GateGoat.Fees.create_fee(%{name: "Site"})
{:ok, camping_fee} =  GateGoat.Fees.create_fee(%{name: "Camping"})

event_changeset1 = Event.changeset(
  %Event{},
  %{
    event_name: "The Balanced Scadians Spa Retreat",
    event_date: ~D[2022-12-08],
    checks_payable: "Barony of Something or Another",
    feast_available: true
  }
)

event_changeset2 = Event.changeset(
  %Event{},
  %{
    event_name: "Arts and Sciences Extravaganza",
    event_date: ~D[2020-12-20],
    checks_payable: "Barony of Awesomesauce",
    feast_available: true
  }
)

event_changeset3 = Event.changeset(
  %Event{},
  %{
    event_name: "All Fighting, All the Time",
    event_date: ~D[2020-05-04],
    checks_payable: "Marche of Melee",
    feast_available: true
  }
)

event1 = Repo.insert!(event_changeset1)
event2 = Repo.insert!(event_changeset2)
event3 = Repo.insert!(event_changeset3)

event1_feast = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event1.id,
    fee_id: feast_fee.id,
    amount: Decimal.new(10)
  }
)

event1_site = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event1.id,
    fee_id: site_fee.id,
    amount: Decimal.new(5)
  }
)

event1_camping = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event1.id,
    fee_id: camping_fee.id,
    amount: Decimal.new(3)
  }
)

event1_feast_fee = Repo.insert!(event1_feast)
event1_site_fee = Repo.insert!(event1_site)
event1_camping_fee = Repo.insert!(event1_camping)

event2_feast = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event2.id,
    fee_id: feast_fee.id,
    amount: Decimal.new(8)
  }
)

event2_site = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event2.id,
    fee_id: site_fee.id,
    amount: Decimal.new(12)
  }
)

event2_camping = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event2.id,
    fee_id: camping_fee.id,
    amount: Decimal.new(0)
  }
)

event2_feast_fee = Repo.insert!(event2_feast)
event2_site_fee = Repo.insert!(event2_site)
event2_camping_fee = Repo.insert!(event2_camping)

event3_feast = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event3.id,
    fee_id: feast_fee.id,
    amount: Decimal.new(10)
  }
)

event3_site = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event3.id,
    fee_id: site_fee.id,
    amount: Decimal.new(5)
  }
)

event3_camping = EventFee.changeset(
  %EventFee{},
  %{
    event_id: event3.id,
    fee_id: camping_fee.id,
    amount: Decimal.new(12)
  }
)

event2_feast_fee = Repo.insert!(event3_feast)
event2_site_fee = Repo.insert!(event3_site)
event2_camping_fee = Repo.insert!(event3_camping)

{:ok, reg1} = GateGoat.Registrations.create_registration(%{
  "membership_number" => "1234",
  "membership_expiration_date" => "12/20/2023",
  "legal_name" => "Person One",
  "sca_name" => "Scadian One",
  "waiver" => true,
  "member_option" => true,}, 1)

{:ok, reg2} = GateGoat.Registrations.create_registration(%{
  "membership_number" => "4567",
  "membership_expiration_date" => "11/20/2022",
  "legal_name" => "Person Two",
  "sca_name" => "Scadian Two",
  "waiver" => true,
  "member_option" => true}, 2)

{:ok, reg3} = GateGoat.Registrations.create_registration(%{
  "membership_number" => "890",
  "membership_expiration_date" => "04/15/2027",
  "legal_name" => "Person Three",
  "sca_name" => "Scadian Three",
  "waiver" => true,
  "member_option" => true}, 3)

Repo.insert!(RegistrationEventFee.changeset(
  %RegistrationEventFee{},
  %{
    registration_id: reg1.id,
    event_fee_id: event1_camping_fee.id,
    selected: true
  }
))

Repo.insert!(RegistrationEventFee.changeset(
  %RegistrationEventFee{},
  %{
    registration_id: reg1.id,
    event_fee_id: event1_site_fee.id,
    selected: true
  }
))

Repo.insert!(RegistrationEventFee.changeset(
  %RegistrationEventFee{},
  %{
    registration_id: reg1.id,
    event_fee_id: event1_feast_fee.id,
    selected: false
  }
))

Repo.insert!(RegistrationEventFee.changeset(
  %RegistrationEventFee{},
  %{
    registration_id: reg2.id,
    event_fee_id: event2_camping_fee.id,
    selected: false
  }
))

Repo.insert!(RegistrationEventFee.changeset(
  %RegistrationEventFee{},
  %{
    registration_id: reg2.id,
    event_fee_id: event2_site_fee.id,
    selected: true
  }
))

Repo.insert!(RegistrationEventFee.changeset(
  %RegistrationEventFee{},
  %{
    registration_id: reg2.id,
    event_fee_id: event2_feast_fee.id,
    selected: true
  }
))

Activities.create_activity(%{
  name: "Tea Time",
  start_time: ~N[2022-12-08 11:00:00],
  duration: 30,
  description: "Drink delicious tea.",
  owner: "Brighid",
  event_id: 1
})

Activities.create_activity(%{
  name: "Scribal Time",
  start_time: ~N[2022-12-08 15:00:00],
  duration: 60,
  description: "Make scrolls.",
  owner: "Brighid",
  event_id: 2
})

Activities.create_activity(%{
  name: "OMG SUCH FIGHTING",
  start_time: ~N[2022-12-08 08:30:00],
  duration: 120,
  description: "HIT PEOPLE",
  owner: "Sir Fighting McFighter",
  event_id: 3
})

Activities.create_activity(%{
  name: "Court",
  start_time: ~N[2022-12-08 17:00:00],
  duration: 120,
  description: "Court",
  owner: "Royalty",
  event_id: 3
})
