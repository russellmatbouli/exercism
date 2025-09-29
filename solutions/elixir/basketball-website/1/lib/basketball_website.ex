defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    [h | t] = String.split(path, ".")
    do_extract(data[h], t)
  end

  def do_extract(data, []), do: data
  def do_extract(data, path) do
    [h | t] = path
    do_extract(data[h], t)
  end

  def get_in_path(data, path) do
    get_in(data, String.split(path, "."))
  end
end
