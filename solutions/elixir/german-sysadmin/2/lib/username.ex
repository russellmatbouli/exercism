defmodule Username do
  def sanitize([]) do
    []
  end

  def sanitize([head | tail]) do
    # ä becomes ae
    # ö becomes oe
    # ü becomes ue
    # ß becomes ss

    sanitized = case head do
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
      x when (x >= ?a and x <= ?z) -> [x]
      ?_ -> ~c"_"
      _ -> ~c""
    end
    sanitized ++ sanitize(tail)
  end
end
