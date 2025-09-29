defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    do_numeral(number, "")
  end
  defp do_numeral(0, acc), do: acc
  defp do_numeral(number, acc) when number >= 1000, do: do_numeral(number - 1000, acc <> "M")
  defp do_numeral(number, acc) when number >= 900, do: do_numeral(number - 900, acc <> "CM")
  defp do_numeral(number, acc) when number >= 500, do: do_numeral(number - 500, acc <> "D")
  defp do_numeral(number, acc) when number >= 400, do: do_numeral(number - 400, acc <> "CD")
  defp do_numeral(number, acc) when number >= 100, do: do_numeral(number - 100, acc <> "C")
  defp do_numeral(number, acc) when number >= 90, do: do_numeral(number - 90, acc <> "XC")
  defp do_numeral(number, acc) when number >= 50, do: do_numeral(number - 50, acc <> "L")
  defp do_numeral(number, acc) when number >= 40, do: do_numeral(number - 40, acc <> "XL")
  defp do_numeral(number, acc) when number >= 10, do: do_numeral(number - 10, acc <> "X")
  defp do_numeral(number, acc) when number >= 9, do: do_numeral(number - 9, acc <> "IX")
  defp do_numeral(number, acc) when number >= 5, do: do_numeral(number - 5, acc <> "V")
  defp do_numeral(number, acc) when number >= 4, do: do_numeral(number - 4, acc <> "IV")
  defp do_numeral(number, acc) when number >= 1, do: do_numeral(number - 1, acc <> "I")
end
