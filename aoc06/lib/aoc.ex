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

  def population(fish, days) do
    fish =
      Enum.reduce(1..days, fish, fn _, fish ->
        new_fish = Map.get(fish, 0, 0)

        fish =
          Enum.reduce(0..7, %{}, fn gen, new ->
            count = Map.get(fish, gen + 1, 0)

            if gen == 6 do
              # new_fish is also number fish starting over
              Map.put(new, gen, count + new_fish)
            else
              Map.put(new, gen, count)
            end
          end)

        Map.put(fish, 8, new_fish)
      end)

    Map.values(fish)
    |> Enum.sum()
  end

  def part1(fish) do
    population(fish, 80)
  end

  def part2(fish) do
    population(fish, 256)
  end
end
