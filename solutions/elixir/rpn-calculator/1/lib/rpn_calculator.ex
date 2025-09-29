defmodule RPNCalculator do
  def calculate!(stack, operation) do
    try do
      operation.(stack)
    rescue
      e in ArgumentError -> raise e
    end
  end

  def calculate(stack, operation) do
    try do
      msg = operation.(stack)
      {:ok, msg}
    rescue
      _ -> :error
    end
  end

  def calculate_verbose(stack, operation) do
    try do
      msg = operation.(stack)
      {:ok, msg}
    rescue
      e in ArgumentError -> {:error, e.message}
    end
  end
end
