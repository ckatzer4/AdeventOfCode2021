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

  def parse_rule(line) do
    String.split(line, " -> ")
    |> List.to_tuple()
  end

  def parse(text) do
    {chain, rules} =
      String.split(text, "\n\n", trim: true)
      |> List.to_tuple()

    rules =
      String.split(rules, "\n", trim: true)
      |> Enum.map(&parse_rule/1)
      |> Map.new()

    {chain, rules}
  end

  def react(chain, rules) do
    String.graphemes(chain)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a | b] ->
      insert = Map.fetch!(rules, a <> hd(b))
      {a, insert, hd(b)}
    end)
    |> Enum.reduce("", fn {a, b, c}, new ->
      if new == "" do
        a <> b <> c
      else
        new <> b <> c
      end
    end)
  end

  def part1({chain, rules}) do
    counts =
      Enum.reduce(1..10, chain, fn _, chain ->
        react(chain, rules)
      end)
      |> String.graphemes()
      |> Enum.frequencies()

    {_, min} = Enum.min_by(counts, &elem(&1, 1))
    {_, max} = Enum.max_by(counts, &elem(&1, 1))
    max - min
  end

  def react_pairs(pairs, rules) do
    # if we know counts before, we can make this simpler
    # say 37 KO pairs will lead to 37 KC and CO pairs
    Enum.flat_map(pairs, fn {pair, count} ->
      insert = Map.fetch!(rules, pair)
      {a, b} = String.graphemes(pair) |> List.to_tuple()
      [{a <> insert, count}, {insert <> b, count}]
    end)
    |> Enum.reduce(%{}, fn {pair, c}, pairs ->
      Map.update(pairs, pair, c, &(&1 + c))
    end)
  end

  def part2({chain, rules}) do
    pairs =
      String.graphemes(chain)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&List.to_tuple/1)
      |> Enum.map(fn {a, b} -> a <> b end)
      |> Enum.frequencies()

    pairs =
      Enum.reduce(1..40, pairs, fn _, pairs ->
        react_pairs(pairs, rules)
      end)

    counts =
      Enum.map(pairs, fn {p, c} ->
        a = String.graphemes(p) |> hd()
        {a, c}
      end)
      |> Enum.reduce(%{}, fn {char, count}, counts ->
        Map.update(counts, char, count, &(&1 + count))
      end)

    # plus the last char - yes it mattered for my input
    last =
      String.graphemes(chain)
      |> Enum.reverse()
      |> hd()

    counts = Map.update!(counts, last, &(&1 + 1))

    {_, min} = Enum.min_by(counts, &elem(&1, 1))
    {_, max} = Enum.max_by(counts, &elem(&1, 1))
    max - min
  end
end
