defmodule BirdCount do
  def today(list) do
    List.first(list)
  end

  def increment_day_count([]) do
    [1]
  end
  def increment_day_count([today | days]) do
    [today + 1 | days]
  end

  def has_day_without_birds?(list) do
    0 in list
  end

  def total(list) do
    Enum.reduce(list, 0, &+/2)
  end

  def busy_days(list) do
    list
    |> Enum.filter(&(&1 >= 5))
    |> Enum.count()
  end
end
