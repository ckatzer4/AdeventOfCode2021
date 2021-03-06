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
    ints =
      String.split(text, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    ints
  end

  def part1(ints) do
    Enum.chunk_every(ints, 2, 1, :discard)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.count(fn {a, b} -> a < b end)
  end

  def part2(ints) do
    Enum.chunk_every(ints, 3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.count(fn {a, b} -> a < b end)
  end
end
