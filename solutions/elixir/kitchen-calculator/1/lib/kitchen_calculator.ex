defmodule KitchenCalculator do
  def get_volume(volume_pair) do
    elem(volume_pair, 1)
  end

  def to_milliliter({:cup, qty}) do
    {:milliliter, qty * 240}
  end
  def to_milliliter({:fluid_ounce, qty}) do
    {:milliliter, qty * 30}
  end
  def to_milliliter({:teaspoon, qty}) do
    {:milliliter, qty * 5}
  end
  def to_milliliter({:tablespoon, qty}) do
    {:milliliter, qty * 15}
  end
  def to_milliliter({:milliliter, qty}) do
    {:milliliter, qty}
  end

  def from_milliliter(volume_pair, :cup) do
    {:cup, get_volume(to_milliliter(volume_pair)) / 240}
  end
  def from_milliliter(volume_pair, :fluid_ounce) do
    {:fluid_ounce, get_volume(to_milliliter(volume_pair)) / 30}
  end
  def from_milliliter(volume_pair, :teaspoon) do
    {:teaspoon, get_volume(to_milliliter(volume_pair)) / 5}
  end
  def from_milliliter(volume_pair, :tablespoon) do
    {:tablespoon, get_volume(to_milliliter(volume_pair)) / 15}
  end
  def from_milliliter(volume_pair, :milliliter) do
    {:milliliter, get_volume(to_milliliter(volume_pair))}
  end

  def convert(volume_pair, unit) do
    from_milliliter({:milliliter, get_volume(to_milliliter(volume_pair))}, unit)
  end
end
