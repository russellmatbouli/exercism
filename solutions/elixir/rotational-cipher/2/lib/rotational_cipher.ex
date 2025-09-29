defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) when shift == 0 or shift == 26, do: text
  def rotate(text, shift) do
    text
    |> String.to_charlist()
    |> Enum.reduce([], &([do_rotate(&1, shift) | &2]))
    |> Enum.reverse()
    |> List.to_string()
  end

  defp do_rotate(text, shift) when text >= ?a and text <= ?z and text + shift > ?z, do: text + shift - 26
  defp do_rotate(text, shift) when text >= ?a and text <= ?z, do: text + shift
  defp do_rotate(text, shift) when text >= ?A and text <= ?Z and text + shift > ?Z, do: text + shift - 26
  defp do_rotate(text, shift) when text >= ?A and text <= ?Z, do: text + shift
  defp do_rotate(text, _shift), do: text
end
