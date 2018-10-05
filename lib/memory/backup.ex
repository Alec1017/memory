defmodule Memory.Backup do
  # ATTRIBUTION: This code is based on the backup_agent.ex file 
  # in the hangman app of Nat's notes seen in class.

  use Agent

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def backup_state(name, game) do
    Agent.update __MODULE__, fn state ->
      Map.put(state, name, game)
    end
  end

  def get_backup(name) do
    Agent.get __MODULE__, fn state ->
      Map.get(state, name)
    end
  end
end