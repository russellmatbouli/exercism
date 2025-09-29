defmodule ProteinTranslation do
  @rna_map %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP",
  }
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(rna) do
    rna
    |> String.to_charlist()
    |> Enum.chunk_every(3)
    |> reduce_rna([])
  end

  defp reduce_rna([], {:error, _}), do: {:error, "invalid RNA"}
  defp reduce_rna([], acc), do: {:ok, Enum.reverse(acc)}
  defp reduce_rna([r | rna], acc) do
    {rs, as} = r
    |> List.to_string()
    |> String.upcase()
    |> of_codon()
    |> map_codon(rna, acc)
    reduce_rna(rs, as)
  end

  defp map_codon({:error, msg}, _, _), do: {[], {:error, msg}}
  defp map_codon({:ok, "STOP"}, _, acc), do: {[], acc}
  defp map_codon({:ok, p}, rna, acc), do: {rna, [p | acc]}

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    protein = Map.get(@rna_map, codon, {:error, "invalid codon"})
    case protein do
      {:error, msg} -> {:error, msg}
      _ -> {:ok, protein}
    end
  end
end
