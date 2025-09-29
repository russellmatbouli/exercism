defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when is_integer(count) and count > 0 do
    do_nth(2, [], count)
  end

  defp do_nth(_from, acc, count) when length(acc) == count, do: Enum.at(acc, 0)

  defp do_nth(from, acc, count) do
    acc = if Enum.all?(acc, &(rem(from, &1) != 0)), do: [from | acc], else: acc
    do_nth(from + 1, acc, count)
  end
end
