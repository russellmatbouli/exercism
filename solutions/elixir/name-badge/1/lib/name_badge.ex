defmodule NameBadge do
  def print(id, name, nil), do: print(id, name, "owner")
  def print(id, name, department) when is_nil(id) do
    "#{name} - #{String.upcase(department)}"
  end

  def print(id, name, department) do
    "[#{id}] - #{name} - #{String.upcase(department)}"
  end
end
