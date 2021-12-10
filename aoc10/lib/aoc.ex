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
    String.split(text, "\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def part1(lines) do
    Enum.map(lines, &Parser.corrupted(&1, :normal))
    |> Enum.sum()
  end

  def part2(lines) do
    scores =
      Enum.filter(lines, fn line ->
        Parser.corrupted(line, :normal) == 0
      end)
      |> Enum.map(&Parser.corrupted(&1, :incomplete))
      |> Enum.sort()

    i = floor(length(scores) / 2)
    Enum.at(scores, i)
  end
end

defmodule Parser do
  def corrupted(line, mode) do
    corrupted(line, [], mode)
  end

  def corrupted([], stack, mode) do
    if mode == :incomplete do
      stack_score(stack)
    else
      0
    end
  end

  def corrupted([g | line], stack, mode) do
    case g do
      "(" ->
        corrupted(line, [")"] ++ stack, mode)

      "[" ->
        corrupted(line, ["]"] ++ stack, mode)

      "{" ->
        corrupted(line, ["}"] ++ stack, mode)

      "<" ->
        corrupted(line, [">"] ++ stack, mode)

      _ ->
        [exp | stack] = stack

        if g == exp do
          corrupted(line, stack, mode)
        else
          score(g)
        end
    end
  end

  def score(g) do
    case g do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end

  def stack_score(stack) do
    Enum.reduce(stack, 0, fn g, score ->
      score = score * 5

      case g do
        ")" -> score + 1
        "]" -> score + 2
        "}" -> score + 3
        ">" -> score + 4
      end
    end)
  end
end
