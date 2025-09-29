defmodule SecretHandshake do
  @codes [
    "wink",
    "double blink",
    "close your eyes",
    "jump",
  ]
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    code + 32
    |> Integer.to_charlist(2)
    |> List.delete_at(0)
    |> Enum.reverse()
    |> do_commands(0, [])
  end

  defp do_commands([h | _code], 4, acc) when h == ?0, do: Enum.reverse(acc)
  defp do_commands(_code, 4, acc), do: acc
  defp do_commands([h | code], pos, acc) when h == ?1, do: do_commands(code, pos + 1, [Enum.at(@codes, pos) | acc])
  defp do_commands([_ | code], pos, acc), do: do_commands(code, pos + 1, acc)
end
