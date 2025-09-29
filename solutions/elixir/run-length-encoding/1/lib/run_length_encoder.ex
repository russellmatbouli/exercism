defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string), do: do_encode(String.to_charlist(string), {"", 0}, [])

  defp do_encode([], {i, num}, acc), do: write({i, num}, acc) |> List.to_string()
  defp do_encode([hd | rem], {hd, num}, acc), do: do_encode(rem, {hd, num + 1}, acc)
  defp do_encode([hd | rem], {x, num}, acc), do: do_encode(rem, {hd, 1}, write({x, num}, acc))

  defp write({c, 0}, acc), do: acc
  defp write({c, 1}, acc), do: acc ++ [c]
  defp write({c, num}, acc), do: acc ++ Integer.to_charlist(num) ++ [c]

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    Regex.replace(
      ~r/(\d+)(.)/,
      string,
      fn _, x, y -> String.duplicate(y, String.to_integer(x)) end,
      global: true
    )
  end
end
