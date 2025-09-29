defmodule TakeANumber do
  def start() do
    spawn(fn -> loop(0) end)
  end

  defp loop(c) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, c)
        loop(c)
      {:take_a_number, sender_pid} ->
        c = c+1
        send(sender_pid, c)
        loop(c)
      :stop -> nil
      _ -> loop(c)
    end
  end
end
