defmodule Theta.CacheDB do
  @moduledoc """
  The Cachedb.
  """

  use GenServer
  alias :ets, as: Ets

  # 1 ngay
  # @expired_after 60 * 60 * 24

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def set(key, value) do
    GenServer.cast(__MODULE__, {:set, key, value})
  end

  #  @doc """
  #  Custom TTL for cache entry
  #  ttl: Time to live in second
  #  """
  def set(key, value, ttl) do
    GenServer.cast(__MODULE__, {:set, key, value, ttl})
  end

  def get(key, time \\ 0) do
    rs =
      Ets.lookup(:db_cache, key)
      |> List.first()

    if rs == nil do
      {:error, :not_found}
    else
      expired_at = elem(rs, 2)

      cond do
        time == 0 ->
          {:ok, elem(rs, 1)}

        is_number(time) ->
          if NaiveDateTime.diff(
               NaiveDateTime.utc_now(),
               NaiveDateTime.add(expired_at, time * 60, :second)
             ) >= 0 do
            {:error, :expired}
          else
            {:ok, elem(rs, 1)}
          end

        NaiveDateTime.diff(time, expired_at) >= 0 ->
          {:error, :expired}

        true ->
          {:ok, elem(rs, 1)}
      end
    end
  end

  def delete(key) do
    GenServer.cast(__MODULE__, {:delete, key})
  end

  # Server callbacks
  # Server (callbacks)

  @impl true
  def init(state) do
    # Todo: change to :protected
    Ets.new(:db_cache, [:set, :public, :named_table, read_concurrency: true])
    {:ok, state}
  end

  #  @doc """
  #  Default TTL
  #  """
  #  def handle_cast({:set, key, val}, state) do
  #    #    expired_at =
  #    #      NaiveDateTime.utc_now()
  #    #      |> NaiveDateTime.add(@expired_after, :second)
  #
  #    #    Ets.insert(:db_cache, {key, val, expired_at})
  #    Ets.insert(:db_cache, {key, val, true})
  #    {:noreply, state}
  #  end

  @doc """
  Custom TTL
  """
  def handle_cast({:set, key, val}, state) do
    inserted_at = NaiveDateTime.utc_now()
    #      |> NaiveDateTime.add(ttl, :second)

    Ets.insert(:db_cache, {key, val, inserted_at})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:delete, key}, state) do
    Ets.delete(:db_cache, key)
    {:noreply, state}
  end
end
