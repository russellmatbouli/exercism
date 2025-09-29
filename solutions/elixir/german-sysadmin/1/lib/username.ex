defmodule Username do
  def sanitize(username) do
    # ä becomes ae
    # ö becomes oe
    # ü becomes ue
    # ß becomes ss

    username
    |> IO.inspect()
    |> Enum.map(fn x ->
      case x do
        ?ä -> ~c"ae"
        ?ö -> ~c"oe"
        ?ü -> ~c"ue"
        ?ß -> ~c"ss"
        _ -> x
      end
    end)
    |> Enum.filter(&((&1 >= ?a && &1 <= ?z) || &1 == ?_))

  end
end
