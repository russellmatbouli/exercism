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
  defp do_encode(bases, enc) do
    [nucl | tail] = bases
    n = encode_nucleotide(nucl)
    acc = <<enc>> <> <<n>>
    do_encode(tail, acc)
  end

  def decode(dna) do
    do_decode(dna, ~c"")
  end
  def do_decode([], dec), do: dec
  def do_decode(dna, dec) do
    # [head | tail] = dna
    IO.inspect(dna, label: "dna")
    <<head, tail>> = dna
    IO.inspect(head, label: "head")
    head_dec = decode(head)
    new_dec = head_dec ++ dec
    do_decode(tail, new_dec)
  end
end
