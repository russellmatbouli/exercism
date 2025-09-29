defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    {:ok, pid} = Task.start_link(fn -> calculator.(input) end)
    %{pid: pid, input: input}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    Process.link(pid)
    status = receive do
      {:EXIT, ^pid, :normal} -> :ok
      {:EXIT, ^pid, _error} -> :error
    after
      100 -> :timeout
    end
    Map.put(results, input, status)
  end

  def reliability_check(calculator, inputs) do
    trap_exit = Process.flag(:trap_exit, true)
    results = %{}

    out = inputs
    |> Enum.map(fn input -> start_reliability_check(calculator, input) end)
    |> Enum.flat_map(fn x -> await_reliability_check_result(x, results) end)
    |> Enum.into(%{})

    Process.flag(:trap_exit, trap_exit)
    out
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(fn input -> Task.async(fn -> calculator.(input) end) end)
    |> Enum.map(fn x -> Task.await(x, 100) end)
  end
end
