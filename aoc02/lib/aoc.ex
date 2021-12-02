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

  def parse_line(text) do
    {dir, i} = String.split(text) |> List.to_tuple()
    {String.to_atom(dir), String.to_integer(i)}
  end

  def parse(text) do
    ins =
      String.split(text, "\n", trim: true)
      |> Enum.map(&parse_line/1)

    ins
  end

  def part1(ins) do
    {d, h} =
      Enum.reduce(ins, {0, 0}, fn {dir, i}, {depth, horz} ->
        case {dir, i} do
          {:down, i} -> {depth + i, horz}
          {:up, i} -> {depth - i, horz}
          {:forward, i} -> {depth, horz + i}
        end
      end)

    d * h
  end

  def part2(ins) do
    {d, h, _a} =
      Enum.reduce(ins, {0, 0, 0}, fn {dir, i}, {depth, horz, aim} ->
        case {dir, i} do
          {:down, i} -> {depth, horz, aim + i}
          {:up, i} -> {depth, horz, aim - i}
          {:forward, i} -> {depth + aim * i, horz + i, aim}
        end
      end)

    d * h
  end
end
