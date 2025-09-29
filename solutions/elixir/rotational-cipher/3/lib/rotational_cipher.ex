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
    |> Enum.map(&(do_rotate(&1, shift)))
    |> List.to_string()
  end

  defp do_rotate(text, shift) when text in ?a..?z and text + shift > ?z, do: text + shift - 26
  defp do_rotate(text, shift) when text in ?a..?z, do: text + shift
  defp do_rotate(text, shift) when text in ?A..?Z and text + shift > ?Z, do: text + shift - 26
  defp do_rotate(text, shift) when text in ?A..?Z, do: text + shift
  defp do_rotate(text, _shift), do: text
end
