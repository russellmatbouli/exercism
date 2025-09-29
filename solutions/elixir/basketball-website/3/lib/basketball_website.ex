defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    [h | t] = String.split(path, ".")
    do_extract(data[h], t)
  end

  defp do_extract(data, []), do: data
  defp do_extract(data, [h | t]), do: do_extract(data[h], t)

  def get_in_path(data, path) do
    get_in(data, String.split(path, "."))
  end
end
