defmodule React do
  use GenServer
  @opaque cells :: pid

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  @doc """
  Start a reactive system
  """
  @spec new(cells :: [cell]) :: {:ok, pid}
  def new(cells) do
    GenServer.start_link(__MODULE__, cells)
  end

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(cells :: pid, cell_name :: String.t()) :: any()
  def get_value(cells, cell_name) do
    GenServer.call(cells, {:get, cell_name})
  end

  @doc """
  Set the value of an input cell
  """
  @spec set_value(cells :: pid, cell_name :: String.t(), value :: any) :: :ok
  def set_value(cells, cell_name, value) do
    GenServer.cast(cells, {:set, cell_name, value})
  end

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback) do
    GenServer.cast(cells, {:add_callback, cell_name, callback_name, callback})
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, cell_name, callback_name) do
    GenServer.cast(cells, {:remove_callback, cell_name, callback_name})
  end

  @impl GenServer
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl GenServer
  def handle_call({:get, cell_name}, _from, state) do
    value = do_get_value(cell_name, state)
    {:reply, value, state}
  end

  @impl GenServer
  def handle_cast({:set, cell_name, value}, state) do
    state = do_set_value(cell_name, value, state)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:add_callback, cell_name, callback_name, callback_fn}, state) do
    state = do_add_callback(cell_name, callback_name, callback_fn, state)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:remove_callback, cell_name, callback_name}, state) do
    state = do_remove_callback(cell_name, callback_name, state)
    {:noreply, state}
  end

  defp do_get_value(cell_name, state) do
    match =
      state
      |> Enum.find(fn x ->
        case x do
          {:input, ^cell_name, _} -> true
          {:output, ^cell_name, _, _} -> true
          _ -> false
        end
      end)

    case match do
      {:input, _, _} -> get_input_value(match)
      {:output, _, _, _} -> get_output_value(match, state)
      _ -> :error
    end
  end

  defp get_input_value({:input, _, value}), do: value

  defp get_output_value({:output, _, input_cells, callback_fn}, state) do
    input_vals =
      input_cells
      |> Enum.map(fn x -> do_get_value(x, state) end)
      |> IO.inspect(label: "input vals")

    do_callback(callback_fn, input_vals)
  end

  defp do_callback(callback_fn, []), do: callback_fn.()
  defp do_callback(callback_fn, [h | []]), do: callback_fn.(h)
  defp do_callback(callback_fn, [h | [t | []]]), do: callback_fn.(h, t)

  defp do_set_value(cell_name, value, state) do
    {{:input, cell_name, _}, i} =
      state
      |> Enum.with_index()
      |> Enum.find(fn x -> {{:input, ^cell_name, _}, _} = x end)

    state =
      state
      |> List.replace_at(i, {:input, cell_name, value})

    find_callbacks_for_cell_rec(cell_name, state)
    |> IO.inspect(label: "callbacks")
    |> Enum.map(&do_get_value(&1, state))
    |> IO.inspect(label: "callbacks values")

    state
  end

  defp do_add_callback(cell_name, callback_name, callback_fn, state) do
    i =
      state
      |> Enum.with_index()
      |> Enum.find(fn x ->
        case x do
          {{:output, ^callback_name, _, _}, _} -> true
          _ -> false
        end
      end)

    if i do
      state
      |> List.update_at(i, fn x ->
        {:output, callback_name, cells} = x
        {:output, callback_name, cells ++ [cell_name], callback_fn}
      end)
    else
      state ++ [{:output, callback_name, [cell_name], callback_fn}]
    end
  end

  defp find_callbacks_for_cell(cell_name, state) do
    state
    |> Enum.filter(fn x ->
      with {:output, _, cells, _} <- x,
           true <- Enum.any?(cells, &(&1 == cell_name)) do
        true
      else
        _ -> false
      end
    end)
    |> Enum.map(fn {:output, name, _, _} -> name end)
  end

  defp find_callbacks_for_cell_rec([], _state), do: []

  defp find_callbacks_for_cell_rec(cell_name, state) do
    IO.inspect(cell_name, label: "cell_name")
    cells =
      find_callbacks_for_cell(cell_name, state)
      |> IO.inspect(label: "rec")

    # if it's an output cell, find callbacks that use its value
    rec_cells =
      cells
      |> Enum.map(&(find_callbacks_for_cell_rec(&1, state)))

    (cells ++ rec_cells)
    |> Enum.uniq()
    |> Enum.flat_map(&find_callbacks_for_cell(&1, state))
    |> Enum.uniq()
  end

  defp do_remove_callback(cell_name, callback_name, state) do
    found =
      state
      |> Enum.with_index()
      |> Enum.find(fn x ->
        {t, _} = x

        case t do
          {:output, ^callback_name, _, _} -> true
          _ -> false
        end
      end)

    if found do
      {{:output, callback_name, cells, callback_fn}, i} = found

      removed_cells =
        cells
        |> List.delete(cell_name)

      if removed_cells == [] do
        state |> List.delete_at(i)
      else
        state |> List.replace_at(i, {:output, callback_name, removed_cells, callback_fn})
      end
    else
      state
    end
  end
end
