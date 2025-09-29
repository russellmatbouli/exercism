defmodule DNA do
  def encode_nucleotide(code_point) do
    case code_point do
      32 -> 0b0000 # space
      ?A -> 0b0001
      ?C -> 0b0010
      ?G -> 0b0100
      ?T -> 0b1000
      _ -> nil
    end
  end

  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0b0000 -> 32 # space
      0b0001 -> ?A
      0b0010 -> ?C
      0b0100 -> ?G
      0b1000 -> ?T
      _ -> nil
    end
  end

  def encode(dna) do
    do_encode(dna, <<>>)
  end

  defp do_encode([], enc), do: enc
  defp do_encode([nucl | tail], enc) do
    acc = <<enc ::bitstring, encode_nucleotide(nucl) ::4>>
    do_encode(tail, acc)
  end

  def decode(dna) do
    do_decode(dna, ~c"")
  end
  defp do_decode(<<>>, dec), do: dec
  defp do_decode(<<head::4, tail::bitstring>>, dec) do
    do_decode(tail, dec ++ [decode_nucleotide(head)])
  end
end
