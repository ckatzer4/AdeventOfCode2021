defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc.hello()
      :world

  """
  def hello do
    :world
  end

  def parse(text) do
    map =
      String.split(text, "\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {list, r} ->
        Enum.with_index(list)
        |> Enum.map(fn {g, c} ->
          {{r, c}, String.to_integer(g)}
        end)
      end)
      |> Map.new()

    map
  end

  def part1(map) do
    {_, flashes} =
      Enum.reduce(1..100, {map, 0}, fn _, {map, f} ->
        {next, new} = Octo.step(map)
        {next, f + new}
      end)

    flashes
  end

  def find_sync(map, gen) do
    {next, _} = Octo.step(map)

    synced =
      Enum.map(next, &elem(&1, 1))
      |> Enum.all?(&(&1 == 0))

    if synced do
      gen + 1
    else
      find_sync(next, gen + 1)
    end
  end

  def part2(map) do
    find_sync(map, 0)
  end
end

defmodule Octo do
  def step(map) do
    calc_flash(map, Map.keys(map), %{}, MapSet.new())
  end

  def calc_flash(_map, [], next, flashed) do
    {next, MapSet.size(flashed)}
  end

  def calc_flash(map, [co | coords], next, flashed) do
    o = Map.fetch!(map, co)
    i = Map.get(next, co, o)

    case i do
      0 ->
        if MapSet.member?(flashed, co) do
          calc_flash(map, coords, Map.put(next, co, 0), flashed)
        else
          calc_flash(map, coords, Map.put(next, co, 1), flashed)
        end

      9 ->
        flashed = MapSet.put(flashed, co)
        calc_flash(map, neighbors(co) ++ coords, Map.put(next, co, 0), flashed)

      _ ->
        calc_flash(map, coords, Map.put(next, co, i + 1), flashed)
    end
  end

  def neighbors({r, c}) do
    [
      {r - 1, c - 1},
      {r - 1, c},
      {r - 1, c + 1},
      {r, c - 1},
      {r, c + 1},
      {r + 1, c - 1},
      {r + 1, c},
      {r + 1, c + 1}
    ]
    |> Enum.filter(fn {r, c} ->
      r >= 0 && r <= 9 && c >= 0 && c <= 9
    end)
  end

  def print_map(map) do
    Enum.map(0..9, fn r ->
      Enum.map(0..9, &Map.fetch!(map, {r, &1}))
      |> Enum.join()
      |> IO.puts()
    end)

    IO.puts("==========")
  end
end
