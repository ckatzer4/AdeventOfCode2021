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
    {start, final} =
      String.split(line, " -> ")
      |> List.to_tuple()

    {r1, c1} =
      String.split(start, ",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    {r2, c2} =
      String.split(final, ",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    {{r1, c1}, {r2, c2}}
  end

  def parse(text) do
    lines =
      String.split(text, "\n", trim: true)
      |> Enum.map(&parse_line/1)

    lines
  end

  def part1(lines) do
    lines =
      Enum.filter(lines, fn {{r1, c1}, {r2, c2}} ->
        r1 == r2 || c1 == c2
      end)

    map =
      Enum.flat_map(lines, fn {{r1, c1}, {r2, c2}} ->
        if r1 == r2 do
          Enum.map(c1..c2, &{r1, &1})
        else
          Enum.map(r1..r2, &{&1, c1})
        end
      end)
      |> Enum.frequencies()

    Map.values(map)
    |> Enum.count(&(&1 >= 2))
  end

  def part2(lines) do
    map =
      Enum.flat_map(lines, fn {{r1, c1}, {r2, c2}} ->
        cond do
          r1 == r2 ->
            Enum.map(c1..c2, &{r1, &1})

          c1 == c2 ->
            Enum.map(r1..r2, &{&1, c1})

          true ->
            Enum.zip(r1..r2, c1..c2)
        end
      end)
      |> Enum.frequencies()

    Map.values(map)
    |> Enum.count(&(&1 >= 2))
  end
end
