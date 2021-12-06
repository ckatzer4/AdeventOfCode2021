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
    fish =
      String.split(text, ",", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    fish
  end

  def population(fish, 0) do
    Map.values(fish)
    |> Enum.sum()
  end

  def population(fish, days) do
    new_fish = Map.get(fish, 0, 0)

    fish =
      Enum.map(0..8, fn gen ->
        count = Map.get(fish, gen + 1, 0)

        case gen do
          8 -> {gen, new_fish}
          6 -> {gen, count+new_fish}
          _ -> {gen, count}
        end
      end)
      |> Map.new()

    population(fish, days - 1)
  end

  def part1(fish) do
    population(fish, 80)
  end

  def part2(fish) do
    population(fish, 256)
  end
end
