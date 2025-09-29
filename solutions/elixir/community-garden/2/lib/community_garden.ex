# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  use Agent

  defstruct [
    plots: [],
    inc: 0
  ]

  def start(_opts \\ [])
  def start(_opts) do
    Agent.start(fn -> %CommunityGarden{} end)
  end

  def list_registrations(pid) do
    Agent.get(pid, &(&1.plots))
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid,
      fn x ->
        plot = %Plot{plot_id: x.inc + 1, registered_to: register_to}
        {plot, %CommunityGarden{plots: [plot | x.plots], inc: x.inc + 1}}
      end
    )
  end

  def release(pid, plot_id) do
    Agent.update(pid,
    fn x ->
      plots = x.plots |> Enum.filter(&(&1.plot_id != plot_id))
      %CommunityGarden{plots: plots, inc: x.inc}
    end)
  end

  def get_registration(pid, plot_id) do
    list_registrations(pid)
    |> Enum.find(
      {:not_found, "plot is unregistered"},
      &(&1.plot_id == plot_id)
    )
  end
end
