defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    case abs(x ** 2) + abs(y ** 2) do
      x when x <= 1 -> 10
      x when x <= 5*5 -> 5
      x when x <= 10*10 -> 1
      _ -> 0
    end
  end
end
