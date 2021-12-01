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
  end

  def part2(ints) do
  end
end
