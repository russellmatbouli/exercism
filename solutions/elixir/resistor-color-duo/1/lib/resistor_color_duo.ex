defmodule ResistorColorDuo do
  @colour_map %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9,
  }
  @doc """
  Calculate a resistance value from two colors
  """
  @spec value(colors :: [atom]) :: integer
  def value(colors) do
    colors
    |> Enum.take(2)
    |> Enum.reduce("",
      fn i, acc ->
        acc <> (@colour_map |> Map.get(i, 0) |> Integer.to_string())
    end)
    |> String.to_integer()
  end
end
