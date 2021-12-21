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
    |> Enum.with_index()
    |> Enum.map(fn {g, c} -> {{r, c}, g == "#"} end)
  end

  def parse(text) do
    [algo, map] = String.split(text, "\n\n", trim: true)

    algo =
      String.graphemes(algo)
      |> Enum.map(&(&1 == "#"))
      |> Enum.with_index()
      |> Enum.map(fn {g, i} -> {i, g} end)
      |> Map.new()

    map =
      String.split(map, "\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(&parse_line/1)
      |> Map.new()

    {algo, map}
  end

  def part1({algo, map}) do
    {step1, def1} = Scan.enhance(algo, map)
    {step2, _def2} = Scan.enhance(algo, step1, def1)

    Map.values(step2)
    |> Enum.count(& &1)
  end

  def part2({algo, map}) do
    {map, _df} =
      Enum.reduce(1..50, {map, false}, fn _, {map, df} ->
        Scan.enhance(algo, map, df)
      end)

    Map.values(map)
    |> Enum.count(& &1)
  end
end

defmodule Scan do
  def enhance(algo, map, default \\ false) do
    {cmin, cmax, rmin, rmax} =
      Map.keys(map)
      |> Enum.reduce({0, 0, 0, 0}, fn {r, c}, acc ->
        {rmin, rmax, cmin, cmax} = acc
        rmin = if r < rmin, do: r, else: rmin
        rmax = if r > rmax, do: r, else: rmax
        cmin = if c < cmin, do: c, else: cmin
        cmax = if c > cmax, do: c, else: cmax
        {cmin, cmax, rmin, rmax}
      end)

    step =
      Enum.flat_map((rmin - 1)..(rmax + 1), fn r ->
        Enum.map((cmin - 1)..(cmax + 1), fn c ->
          ind =
            block({r, c})
            |> Enum.map(&Map.get(map, &1, default))
            |> Enum.map(fn g -> if g, do: "1", else: "0" end)
            |> Enum.join()
            |> String.to_integer(2)

          {{r, c}, Map.fetch!(algo, ind)}
        end)
      end)
      |> Map.new()

    new_def =
      if default do
        ind = String.to_integer("111111111", 2)
        Map.fetch!(algo, ind)
      else
        ind = String.to_integer("000000000", 2)
        Map.fetch!(algo, ind)
      end

    {step, new_def}
  end

  def block({r, c}) do
    [
      {r - 1, c - 1},
      {r - 1, c},
      {r - 1, c + 1},
      {r, c - 1},
      {r, c},
      {r, c + 1},
      {r + 1, c - 1},
      {r + 1, c},
      {r + 1, c + 1}
    ]
  end
end
