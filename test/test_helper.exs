ExUnit.start()
Application.ensure_all_started(:double)

Ecto.Adapters.SQL.Sandbox.mode(GateGoat.Repo, :manual)

