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
      String.split(text, ",", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    ints
  end

  def fuel_cost(ints, target) do
    Enum.map(ints, &abs(&1 - target))
    |> Enum.sum()
  end

  def part1(ints) do
    min_pos = Enum.min(ints)
    max_pos = Enum.max(ints)

    Enum.map(min_pos..max_pos, &fuel_cost(ints, &1))
    |> Enum.min()
  end

  def real_fuel_cost(ints, target) do
    Enum.map(ints, &abs(&1 - target))
    # each step costs increasingly more, 1+2+3+4...
    # SUM(1..n) === n*(n+1)/2
    # round() returns integer instead of floats
    |> Enum.map(&(round(&1*(&1+1)/2)))
    |> Enum.sum()
  end

  def part2(ints) do
    min_pos = Enum.min(ints)
    max_pos = Enum.max(ints)

    Enum.map(min_pos..max_pos, &real_fuel_cost(ints, &1))
    |> Enum.min()
  end
end
