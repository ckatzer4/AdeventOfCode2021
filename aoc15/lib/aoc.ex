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

  def parse_line({line, r}) do
    String.graphemes(line)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {g, c} -> {{r, c}, g} end)
  end

  def parse(text) do
    map =
      String.split(text, "\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(&parse_line/1)
      |> Map.new()

    map
  end

  def part1(map) do
    DFS.best_path(map)
  end

  def part2(map) do
    {rmax, cmax} = DFS.target(map)
    rmax = rmax + 1
    cmax = cmax + 1

    big_map =
      Enum.reduce(0..4, map, fn i, row_map ->
        Enum.reduce(0..4, row_map, fn j, big_map ->
          Enum.reduce(map, big_map, fn {{r, c}, v}, big_map ->
            # value wraps from 9 to 1,
            # essentially mod 9 with +1 offset, not mod 10
            Map.put(big_map, {i * rmax + r, j * cmax + c}, rem(v + i + j - 1, 9) + 1)
          end)
        end)
      end)

    DFS.best_path(big_map)
  end
end

defmodule DFS do
  def neighbors({r, c}) do
    [
      {r - 1, c},
      {r, c + 1},
      {r + 1, c},
      {r, c - 1}
    ]
  end

  def target(map) do
    {rmax, _} = Map.keys(map) |> Enum.max_by(&elem(&1, 0))
    {_, cmax} = Map.keys(map) |> Enum.max_by(&elem(&1, 1))
    {rmax, cmax}
  end

  def next_step(co, seen, map, {rmax, cmax}) do
    neighbors(co)
    |> Enum.filter(&(!Map.has_key?(seen, &1)))
    |> Enum.filter(fn {r, c} -> r >= 0 && c >= 0 && r <= rmax && c <= cmax end)
    |> Enum.sort_by(&Map.fetch!(map, &1))
  end

  def find_paths(map, term, frontier, cost_to) do
    {{cost, co}, frontier} = PriorityQueue.pop!(frontier)

    if co == term do
      Map.fetch!(cost_to, term)
    else
      # add all possible nexts
      new_steps = next_step(co, cost_to, map, term)
      current_cost = Map.fetch!(cost_to, co)

      cost_to =
        Enum.map(
          new_steps,
          fn nco -> {nco, current_cost + Map.fetch!(map, nco)} end
        )
        |> Enum.reduce(cost_to, fn {nco, cost}, cost_to ->
          Map.put_new(cost_to, nco, cost)
        end)

      # frontier must always be sorted by cost+distance
      frontier =
        Enum.reduce(new_steps, frontier, fn nco, pq ->
          PriorityQueue.put(pq, priority(nco, cost_to), nco)
        end)

      find_paths(map, term, frontier, cost_to)
    end
  end

  def priority({r, c}, cost_to) do
    # if you wanted to be cool and do A* instead of Dijkstra's,
    # you put a cool heuristic here and fix my other bugs...
    Map.fetch!(cost_to, {r, c})
  end

  def best_path(map) do
    pq = PriorityQueue.new() |> PriorityQueue.put(0, {0, 0})
    find_paths(map, target(map), pq, %{{0, 0} => 0})
  end
end
