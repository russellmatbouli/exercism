defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    def eat(itemi, character)
  end

  defimpl Edible, for: LoafOfBread do
    def eat(_item, character) do
      character
      |> Map.get_and_update(:health, fn x -> {nil, x + 5} end)
    end
  end

  defimpl Edible, for: ManaPotion do
    def eat(item, character) do
      character
      |> Map.get_and_update(:mana, fn x -> {%EmptyBottle{}, x + item.strength} end)
    end
  end

  defimpl Edible, for: Poison do
    def eat(_item, character) do
      character
      |> Map.get_and_update(:health, fn _ -> {%EmptyBottle{}, 0} end)
    end
  end
end
