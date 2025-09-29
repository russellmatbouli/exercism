defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    pow2(color_count)
  end

  def pow2(count), do: pow2(count, 1)
  def pow2(count, exponent) do
    if count <= 2 ** exponent do
      exponent
    else
      pow2(count, exponent + 1)
    end
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2, 1::2, 2::2, 3::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    size = palette_bit_size(color_count)
    # <<pixel_color_index::size(size)>> <> picture
    <<pixel_color_index::size(size), picture::bitstring>>
  end

  def get_first_pixel(<<>>, _), do: nil
  def get_first_pixel(picture, color_count) do
    size = palette_bit_size(color_count)
    <<x::size(size), tail::bitstring>> = picture
    x
  end

  def drop_first_pixel(<<>>, _), do: empty_picture()
  def drop_first_pixel(picture, color_count) do
    size = palette_bit_size(color_count)
    <<x::size(size), tail::bitstring>> = picture
    tail
  end

  def concat_pictures(picture1, <<>>), do: picture1
  def concat_pictures(<<>>, picture2), do: picture2
  def concat_pictures(<<>>, <<>>), do: <<>>
  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
