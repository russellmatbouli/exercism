defmodule TwoFer do
  @moduledoc """
  Provides a two_for function to create a "two-fer" string.
  """
  @doc """
  Two-fer or 2-fer is short for two for one. One for you and one for me.
  """
  @spec two_fer(String.t()) :: String.t()
  def two_fer(name \\ "you") when is_binary(name), do: "One for #{name}, one for me."
end
