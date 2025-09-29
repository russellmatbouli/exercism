defmodule TopSecret do
  def to_ast(string) do
    {:ok, ast} = Code.string_to_quoted(string)
    ast
  end

  def decode_secret_message_part({f, _, [{name_atom, _, argt}, _] = args} = ast, acc)
      when is_list(args) and f == :def or f == :defp do
    name = if name_atom == :when do
      [{name_atom, _, _}, _] = argt
      name_atom
    else
      name_atom
    end
    |> Atom.to_string()

    args = if name_atom == :when, do: argt, else: args
    parity = get_parity(args)
    short_name = shorten_name(name, parity)
    {ast, [short_name | acc]}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp get_parity(args) do
    with [{_, _, params}, _] <- args,
      true <- is_list(params),
      parity <- length(params)
    do
      parity
    else
      _ -> 0
    end
  end

  defp shorten_name(name, parity) do
    if parity == 0 do
      ""
    else
      String.slice(name, 0..max(0, parity-1))
    end
  end

  def decode_secret_message(string) do
    {_, secret} = Macro.prewalk(to_ast(string), [], &decode_secret_message_part/2)
    secret
    |> Enum.reverse()
    |> List.to_string()
  end
end
