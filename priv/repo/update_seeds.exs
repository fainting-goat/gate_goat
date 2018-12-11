alias GateGoat.Repo
alias GateGoat.Users.User
alias GateGoat.Users.Role

admin_changest = Role.changeset(
  %Role{},
  %{
    type: "admin"
  }
)

user_changeset = Role.changeset(
  %Role{},
  %{
    type: "user"
  }
)

admin = Repo.insert!(admin_changest)
Repo.insert!(user_changeset)


kelsey_changeset = User.changeset(
  %User{},
  %{
    username: "kelsey",
    password: "password!"
  }
)

Repo.insert!(kelsey_changeset)
