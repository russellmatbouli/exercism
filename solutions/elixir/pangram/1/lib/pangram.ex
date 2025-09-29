defmodule Pangram do
  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    with charmap <-
           sentence
           |> String.downcase()
           |> String.replace(~r/[^a-z]/, "")
           |> String.split(~r//, trim: true)
           |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end),
         26 <- charmap |> Map.keys() |> length(),
         26 <- charmap |> Map.values() |> Enum.filter(&(&1 >= 1)) |> length() do
      true
    else
      _ -> false
    end
  end
end
