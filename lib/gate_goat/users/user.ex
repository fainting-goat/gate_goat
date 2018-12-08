defmodule GateGoat.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Users.Role

  schema "users" do
    field :password, :string
    field :password_hash, :string
    field :username, :string

    has_one :role, Role

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:username, :password])
    |> validate_length(:username, min: 1, max: 20)
    |> validate_length(:password, min: 8, max: 100)
    |> make_password_hash
  end

  def make_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{
          password: password
        }
      } ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    end
  end
end
