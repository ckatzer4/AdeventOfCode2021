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

  def neighbors({r, c}) do
    [{r - 1, c}, {r, c - 1}, {r, c + 1}, {r + 1, c}]
  end

  def lowest?(map, {r, c}) do
    h = Map.fetch!(map, {r, c})

    Enum.map(neighbors({r, c}), fn ncoord ->
      Map.get(map, ncoord, 9) > h
    end)
    |> Enum.all?()
  end

  def part1(map) do
    Map.keys(map)
    |> Enum.filter(fn p -> lowest?(map, p) end)
    |> Enum.map(fn p -> Map.fetch!(map, p) end)
    |> Enum.sum()
  end

  def find_basin(_map, [], basin) do
    basin
  end

  def find_basin(map, points, basin) do
    basin =
      MapSet.new(points)
      |> MapSet.union(basin)

    next =
      Enum.flat_map(points, &neighbors/1)
      |> Enum.filter(fn p ->
        not_in_basin = !MapSet.member?(basin, p)
        h = Map.get(map, p, 9)
        not_in_basin && h < 9
      end)

    find_basin(map, next, basin)
  end

  def part2(map) do
    seeds =
      Map.keys(map)
      |> Enum.filter(fn p -> lowest?(map, p) end)

    empty = MapSet.new()

    sizes =
      Enum.map(seeds, &find_basin(map, [&1], empty))
      |> Enum.map(&MapSet.to_list/1)
      |> Enum.map(&length/1)
      |> Enum.sort()

    Enum.drop(sizes, length(sizes) - 3)
    |> Enum.product()
  end
end
