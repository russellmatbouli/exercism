defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts()) :: error()
  @callback handle_frame(dot(), frame_number(), opts()) :: dot()

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts) do
        {:ok, opts}
      end
      defoverridable(init: 1)
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) do
    if Integer.mod(frame_number, 4) == 0 do
      %{dot | opacity: dot.opacity / 2}
    else
      dot
    end
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    with v <- Keyword.get(opts, :velocity),
         true <- is_integer(v),
         true <- v > 0
    do
      {:ok, opts}
    else
      _ ->
        {:error, "The :velocity option is required, and its value must be a number. Got: #{inspect(Keyword.get(opts, :velocity))}"}
    end
  end
  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, opts) do
    %{dot | radius: dot.radius + (frame_number - 1) * Keyword.get(opts, :velocity)}
  end
end
