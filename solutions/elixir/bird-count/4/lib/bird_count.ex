defmodule BirdCount do
  def today([]), do: nil
  def today([head | _]) do
    head
  end

  def increment_day_count([]), do: [1]
  def increment_day_count([today | days]) do
    [today + 1 | days]
  end

  def has_day_without_birds?(list) do
    0 in list
  end

  def total(list) do
    do_total(list, 0)
  end
  defp do_total([], acc), do: acc
  defp do_total([h | t], acc), do: do_total(t, acc + h)

  def busy_days(list) do
    do_busy_days(list, 0)
  end
  defp do_busy_days([], acc), do: acc
  defp do_busy_days([h | t], acc) when h >= 5, do: do_busy_days(t, acc + 1)
  defp do_busy_days([_ | t], acc), do: do_busy_days(t, acc)
end
