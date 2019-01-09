alias GateGoat.Repo
alias GateGoat.Events.Event
alias GateGoat.Users.User
alias GateGoat.Users.Role

event_changeset1 = Event.changeset(
  %Event{},
  %{
    event_name: "Test Event",
    event_date: ~D[2022-12-08],
    event_fee: 10,
    feast_fee: 10,
    camping_fee: 0,
    checks_payable: "Test Event",
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
