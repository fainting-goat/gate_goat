defmodule GateGoat.Events.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  alias GateGoat.Events.Event

  schema "registrations" do
    field :group_name, :string
    field :membership_number, :string
    field :membership_expiration_date, :date
    field :legal_name, :string
    field :sca_name, :string
    field :waiver, :boolean, default: false
    field :feast_option, :boolean, default: false
    field :camping_option, :boolean, default: false
    field :member_option, :boolean, default: true
    field :verified, :boolean, default: false
    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(registration, %{verified: verified}) do
    registration
    |> cast(%{verified: verified}, [:verified])
  end
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:sca_name, :legal_name, :membership_number, :membership_expiration_date, :group_name, :waiver, :feast_option, :camping_option, :member_option, :verified])
    |> validate_required([:sca_name, :legal_name, :waiver, :feast_option, :camping_option, :member_option])
    |> validate_acceptance(:waiver, [message: "Waiver must be accepted."])
    |> validate_membership_info(attrs)
  end

  def validate_membership_info(changeset, %{"member_option" => "true"} = attrs) do
    changeset
    |> validate_required([:membership_number, :membership_expiration_date])
    |> validate_format(:membership_number, ~r/^\d+$/, [message: "Membership number must be a number."])
    |> validate_expiration_date(:membership_expiration_date)
  end
  def validate_membership_info(changeset, _), do: changeset

  def validate_expiration_date(changeset, field) do
    validate_change(changeset, field, fn _, date ->
      case Date.compare(date, Date.utc_today()) do
        :lt ->  [{field, "Your membership is expired.  Please use the non-member option."}]
        _ -> []
      end
    end)
  end
end
