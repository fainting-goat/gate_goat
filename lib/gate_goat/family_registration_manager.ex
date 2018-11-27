defmodule GateGoat.FamilyRegistrationManager do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    {:ok, state}
  end

  #API

  def save_registration(registration, pid) do
    GenServer.call(pid, {:save_registration, registration})
  end

  def get_registrations(pid) do
    GenServer.call(pid, {:get_registrations})
  end

  #CALLBACKS

  def handle_call({:save_registration, registration}, _from, state) do
    {:reply, {:ok}, [registration | state]}
  end

  def handle_call({:get_registrations}, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
