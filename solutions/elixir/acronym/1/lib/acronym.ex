defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string = Regex.replace(~r/[-]/, string, " ")
    Regex.replace(~r/[[:punct:]]/, string, "")
    |> String.split()
    |> Enum.map(fn x ->
        x
        |> String.first()
        |> String.upcase()
      end)
    |> Enum.join()
  end
end
