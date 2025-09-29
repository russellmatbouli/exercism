defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class() do
    Enum.random(@planetary_classes)
  end

  def random_ship_registry_number() do
    "NCC-" <> Integer.to_string(round(:rand.uniform() * (9999 - 1000) + 1000))
  end

  def random_stardate() do
    :rand.uniform() * (42000 - 41000) + 41000
  end

  def format_stardate(stardate) do
    :io_lib.format("~.1f", [stardate])
    |> to_string
  end
end
