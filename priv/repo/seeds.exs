alias GateGoat.Repo
alias GateGoat.Events.Event
alias GateGoat.Users.User
alias GateGoat.Users.Role
alias GateGoat.Events.Fee
alias GateGoat.Events.EventFee
alias GateGoat.Events.RegistrationEventFee

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

{:ok, feast_fee} = GateGoat.Events.create_fee(%{name: "Feast"})
{:ok, site_fee} =  GateGoat.Events.create_fee(%{name: "Site"})
{:ok, camping_fee} =  GateGoat.Events.create_fee(%{name: "Camping"})

event_changeset1 = Event.changeset(
  %Event{},
  %{
    event_name: "Test Event",
    event_date: ~D[2022-12-08],
    checks_payable: "Test Event",
    feast_available: true
  }
)

event_changeset2 = Event.changeset(
  %Event{},
  %{
    event_name: "Demo Event",
    event_date: ~D[2020-12-20],
    checks_payable: "Demo Event",
    feast_available: true
  }
)

event1 = Repo.insert!(event_changeset1)
event2 = Repo.insert!(event_changeset2)

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

{:ok, reg1} = GateGoat.Events.create_registration(%{
  "membership_number" => "1234",
  "membership_expiration_date" => "12/20/2023",
  "legal_name" => "test",
  "sca_name" => "test",
  "waiver" => true,
  "member_option" => true,}, 1)

{:ok, reg2} = GateGoat.Events.create_registration(%{
  "membership_number" => "1234",
  "membership_expiration_date" => "12/20/2023",
  "legal_name" => "test",
  "sca_name" => "test",
  "waiver" => true,
  "member_option" => true}, 2)

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
