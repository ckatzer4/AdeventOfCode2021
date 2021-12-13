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
    {dots, folds} =
      String.split(text, "\n\n", trim: true)
      |> List.to_tuple()

    dots =
      String.split(dots, "\n", trim: true)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&List.to_tuple/1)
      |> Enum.map(fn {r, c} ->
        {String.to_integer(r), String.to_integer(c)}
      end)
      |> MapSet.new()

    folds =
      String.split(folds, "\n", trim: true)
      |> Enum.map(&String.split/1)
      |> Enum.map(&List.to_tuple/1)
      |> Enum.map(fn {_, _, line} ->
        [dir | int] = String.split(line, "=")
        {String.to_atom(dir), String.to_integer(hd(int))}
      end)

    {dots, folds}
  end

  def part1({dots, folds}) do
    Paper.fold(dots, hd(folds))
    |> MapSet.size()
  end

  def part2({dots, folds}) do
    Enum.reduce(folds, dots, fn fold, dots ->
      Paper.fold(dots, fold)
    end)
    |> Paper.print()
  end
end

defmodule Paper do
  def fold(dots, {dir, int}) do
    case dir do
      # fold along row int
      :x ->
        Enum.map(dots, fn {r, c} ->
          if r < int do
            {r, c}
          else
            {int - (r - int), c}
          end
        end)

      :y ->
        Enum.map(dots, fn {r, c} ->
          if c < int do
            {r, c}
          else
            {r, int - (c - int)}
          end
        end)
    end
    |> MapSet.new()
  end

  def print(dots) do
    rmax = Enum.map(dots, &elem(&1,0)) |> Enum.max()
    cmax = Enum.map(dots, &elem(&1,1)) |> Enum.max()
    Enum.map(0..cmax, fn c ->
      Enum.map(0..rmax, fn r ->
        if MapSet.member?(dots, {r,c}) do
          "#"
        else
          "."
        end
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end
end
