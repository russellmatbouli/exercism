defmodule TakeANumberDeluxe do
  use GenServer
  alias TakeANumberDeluxe.State, as: State

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)
    GenServer.start_link(__MODULE__, init_arg, [timeout: timeout])
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :get_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset)
  end

  # Server callbacks

  @impl GenServer
  def init(init_arg) do
    min_number = Keyword.get(init_arg, :min_number)
    max_number = Keyword.get(init_arg, :max_number)
    timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)
    with {:ok, state} <- State.new(min_number, max_number, timeout)
    do
      {:ok, state, timeout}
    else
      x -> x
    end
  end

  @impl GenServer
  def handle_call(:get_state, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    with {:ok, new_number, new_state} <- State.queue_new_number(state)
    do
      {:reply, {:ok, new_number}, new_state, state.auto_shutdown_timeout}
    else
      error ->
        {:reply, error, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority}, _from, state) do
    with {:ok, num, new_state} <- State.serve_next_queued_number(state, priority)
    do
      {:reply, {:ok, num}, new_state, state.auto_shutdown_timeout}
    else
      error ->
        {:reply, error, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset, state) do
    with {:ok, new_state} <- State.new(state.min_number, state.max_number, state.auto_shutdown_timeout)
    do
      {:noreply, new_state, state.auto_shutdown_timeout}
    else
      _error ->
        {:noreply, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_info(:timeout, _state) do
    exit(:normal)
  end

  @impl GenServer
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state, state.auto_shutdown_timeout}
  end

end
