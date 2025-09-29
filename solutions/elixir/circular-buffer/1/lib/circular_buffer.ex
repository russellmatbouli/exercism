defmodule CircularBuffer do
  use GenServer
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    GenServer.start_link(__MODULE__, capacity)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    GenServer.call(buffer, :read)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    GenServer.call(buffer, {:write, item})
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    GenServer.call(buffer, {:overwrite, item})
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    GenServer.cast(buffer, :clear)
  end

  @impl GenServer
  def init(capacity) do
    state = %{capacity: capacity, buffer: []}
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:read, _from, %{buffer: []} = state) do
    {:reply, {:error, :empty}, state}
  end

  @impl GenServer
  def handle_call(:read, _from, state) do
    [h | tail] = state.buffer
    state = %{state | buffer: tail}
    {:reply, {:ok, h}, state}
  end

  @impl GenServer
  def handle_call({:write, _item}, _from, %{capacity: c, buffer: b} = state) when length(b) == c do
    {:reply, {:error, :full}, state}
  end

  @impl GenServer
  def handle_call({:write, item}, _from, state) do
    {:reply, :ok, %{state | buffer: state.buffer ++ [item]}}
  end

  @impl GenServer
  def handle_call({:overwrite, item}, _from, %{capacity: c, buffer: b} = state) when length(b) == c do
    [_ | tail] = state.buffer
    {:reply, :ok, %{state | buffer: tail ++ [item]}}
  end

  @impl GenServer
  def handle_call({:overwrite, item}, _from, state) do
    {:reply, :ok, %{state | buffer: state.buffer ++ [item]}}
  end

  @impl GenServer
  def handle_cast(:clear, state) do
    {:noreply, %{state | buffer: []}}
  end
end
