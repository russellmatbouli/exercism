defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_, input_base, _)
    when is_integer(input_base) and input_base < 2, do: {:error, "input base must be >= 2"}
  def convert(_, _, output_base)
    when is_integer(output_base) and output_base < 2, do: {:error, "output base must be >= 2"}
  def convert([], _, _), do: {:ok, [0]}
  def convert(digits, input_base, output_base) when is_integer(input_base) and is_integer(output_base) do
    with :ok <- validate_digits(digits, input_base),
        {:ok, x} <- to_base_10(digits, input_base),
        {:ok, new_digits} <- from_base_10(x, output_base)
    do
      {:ok, new_digits}
    else
      error -> error
    end
  end

  defp validate_digits(digits, base) do
    if Enum.any?(digits, fn x -> x < 0 or x >= base end) do
      {:error, "all digits must be >= 0 and < input base"}
    else
      :ok
    end
  end

  defp to_base_10(digits, base) do
    %{sum: sum}= for digit <- Enum.reverse(digits), reduce: %{sum: 0, iter: 0} do
      acc -> %{sum: (digit * (base ** acc.iter)) + acc.sum, iter: acc.iter + 1}
    end
    {:ok, sum}
  end

  defp from_base_10(number, base) do
    new_digits = to_base_n(number, base, [])
    new_digits = if new_digits == [], do: [0], else: new_digits
    {:ok, new_digits}
  end

  defp to_base_n(0, _base, output), do: output
  defp to_base_n(number, base, output) do
    rem = rem(number, base ** (length(output) + 1))
    digit = div(rem, base ** (length(output)))
    new_num = number - rem
    to_base_n(new_num, base, [digit | output])
  end
end
