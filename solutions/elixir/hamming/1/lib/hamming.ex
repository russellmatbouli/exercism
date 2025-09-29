defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance(~c"AAGTCATA", ~c"TAGCGATC")
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) do
    with true <- length(strand1) == length(strand2),
         num <-
           Enum.to_list(0..length(strand1))
           |> Enum.filter(&(Enum.at(strand1, &1) != Enum.at(strand2, &1)))
           |> Enum.count() do
      {:ok, num}
    else
      _ -> {:error, "strands must be of equal length"}
    end
  end
end
