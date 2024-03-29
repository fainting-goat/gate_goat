defmodule GateGoat.Guardian do
  use Guardian, otp_app: :gate_goat

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    {:ok, %{id: claims["sub"]}}
  end
end
