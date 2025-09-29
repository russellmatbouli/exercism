defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = Integer.digits(number)

    digits
    |> Enum.reverse()
    |> Enum.reduce(0, fn x, acc -> x ** length(digits) + acc end) ==
      number
  end
end
