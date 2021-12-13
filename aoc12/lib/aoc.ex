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

  def parse_line(line) do
    {a, b} =
      String.split(line, "-")
      |> List.to_tuple()

    [{a, b}, {b, a}]
  end

  def parse(text) do
    graph =
      String.split(text, "\n", trim: true)
      |> Enum.flat_map(&parse_line/1)
      |> Enum.reduce(%{}, fn {a, b}, graph ->
        Map.update(graph, a, [b], &[b | &1])
      end)

    graph
  end

  def part1(graph) do
    Graph.paths(graph, "start", :part1)
  end

  def part2(graph) do
    Graph.paths(graph, "start", :part2)
  end
end

defmodule Graph do
  def paths(graph, start, mode) do
    paths(graph, start, mode, %{start => 1})
  end

  def paths(graph, node, mode, seen) do
    if node == "end" do
      1
    else
      next_nodes(graph, node, seen, mode)
      |> Enum.map(fn {next, new_seen} ->
        paths(graph, next, mode, new_seen)
      end)
      |> Enum.sum()
    end
  end

  def next_nodes(graph, a, seen, mode) do
    # given our graph, where can a go to next?
    # Part1:
    # * must not be a lowercase that we already visited
    # Part2:
    # * cannot revisit start
    # * can revisit one lower twice, but only one
    all = Map.fetch!(graph, a)

    Enum.filter(all, fn b ->
      low = b == String.downcase(b)
      visited = Map.get(seen, b, 0)

      if mode == :part1 do
        !(low && visited > 0)
      else
        double_visits =
          Stream.filter(seen, fn {n, _} ->
            n == String.downcase(n)
          end)
          |> Enum.any?(fn {_, c} -> c == 2 end)

        if double_visits do
          !(low && visited > 0)
        else
          !(b == "start")
        end
      end
    end)
    |> Enum.map(fn b -> {b, Map.update(seen, b, 1, &(&1 + 1))} end)
  end
end
