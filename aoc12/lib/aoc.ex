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
    Graph.paths(graph, "end", [["start"]], :part1)
    |> length()
  end

  def part2(graph) do
    Graph.paths(graph, "end", [["start"]], :part2)
    |> length()
  end
end

defmodule Graph do
  def paths(graph, term, paths, mode) do
    # IO.inspect(paths)

    next_paths =
      Enum.flat_map(paths, fn path ->
        a = hd(path)

        if a == term do
          [path]
        else
          next = next_nodes(graph, a, path, mode)
          Enum.map(next, &[&1 | path])
        end
      end)

    IO.puts(length(next_paths))
    IO.puts(Enum.map(next_paths, &length(&1)) |> Enum.sum())
    IO.puts("=====")

    if next_paths == paths do
      paths
    else
      paths(graph, term, next_paths, mode)
    end
  end

  def next_nodes(graph, a, path, mode) do
    # given our graph, where can a go to next?
    # Part1:
    # * must not be a lowercase that we already visited
    # Part2:
    # * cannot revisit start
    # * can revisit one lower twice, but only one
    all = Map.fetch!(graph, a)

    Enum.filter(all, fn b ->
      low = b == String.downcase(b)
      visits = Enum.frequencies(path)
      visited = Map.get(visits, b, 0)

      if mode == :part1 do
        !(low && visited > 0)
      else
        double_visits =
          Stream.filter(visits, fn {n, _} ->
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
  end
end

defmodule MyPath do
  defstruct path: [], visits: %{}, doubled: false

  def from_list(list) do
    Enum.reverse(list)
    |> Enum.reduce(%MyPath{}, fn node, path -> Mypath.push(path, node) end)
  end

  def push(my_path, node) do
    new_path = [node | my_path.path]
    new_visits = Map.update(my_path.visits, node, 1, &(&1 + 1))
    new_doubled = Map.fetch!(new_visits, node) > 1
    %MyPath{path: new_path, visits: new_visits, doubled: new_doubled}
  end

  def visited?(my_path, node) do
    Map.has_key?(my_path.visits, node)
  end
end
