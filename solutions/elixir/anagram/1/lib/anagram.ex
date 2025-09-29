defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    candidates
    |> Enum.filter(&match_word(base, &1))
  end

  defp match_word(base, candidate) do
    b_lc = String.downcase(base)
    c_lc = String.downcase(candidate)

    not String.equivalent?(b_lc, c_lc) and
      c_lc |> String.split("") |> Enum.sort(:asc) ==
        b_lc |> String.split("") |> Enum.sort(:asc)
  end
end
