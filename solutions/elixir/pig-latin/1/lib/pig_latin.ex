defmodule PigLatin do
  @rule1 Regex.compile!("^([aeiou]|xr|yt)(.+)$")
  @rule2 Regex.compile!("^([^aeiou]+)(.+)$")
  @rule3 Regex.compile!("^([^aeiou]*qu)(.+)$")
  @rule4 Regex.compile!("^([^aeiou]+)(y.+)$")

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.reduce([], &translate/2)
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  defp translate(word, acc) do
    pig_latin =
      cond do
        word =~ @rule1 -> Regex.replace(@rule1, word, "\\0ay")
        word =~ @rule3 -> Regex.replace(@rule3, word, "\\2\\1ay")
        word =~ @rule4 -> Regex.replace(@rule4, word, "\\2\\1ay")
        word =~ @rule2 -> Regex.replace(@rule2, word, "\\2\\1ay")
        true -> word
      end

    [pig_latin | acc]
  end
end
