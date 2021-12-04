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
    bins =
      String.split(text, "\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    bins
  end

  def part1(bins) do
    len = length(hd(bins))
    total = length(bins)

    {gamma, epsilon} =
      Enum.reduce(0..(len - 1), {"", ""}, fn pos, {gam, eps} ->
        zeros =
          Enum.count(bins, fn bin ->
            Enum.at(bin, pos) == "0"
          end)

        if zeros > total / 2 do
          {gam <> "0", eps <> "1"}
        else
          {gam <> "1", eps <> "0"}
        end
      end)

    # decode as binary
    gamma = String.to_integer(gamma, 2)
    epsilon = String.to_integer(epsilon, 2)
    gamma * epsilon
  end

  def part2(bins) do
    oxy = BitFilter.oxy_filter(bins)
    oxy = String.to_integer(oxy, 2)
    co2 = BitFilter.co2_filter(bins)
    co2 = String.to_integer(co2, 2)
    oxy * co2
  end
end

defmodule BitFilter do
  def oxy_filter(bins) do
    oxy_filter(bins, [])
  end

  def oxy_filter([last], _prefix) do
    Enum.join(last)
  end

  def oxy_filter(bins, prefix) do
    pos = length(prefix)
    total = length(bins)
    ones = Enum.count(bins, fn bin -> Enum.at(bin, pos) == "1" end)

    prefix =
      if ones >= total / 2 do
        prefix ++ ["1"]
      else
        prefix ++ ["0"]
      end

    bins = Enum.filter(bins, &List.starts_with?(&1, prefix))
    oxy_filter(bins, prefix)
  end

  def co2_filter(bins) do
    co2_filter(bins, [])
  end

  def co2_filter([last], _prefix) do
    Enum.join(last)
  end

  def co2_filter(bins, prefix) do
    pos = length(prefix)
    total = length(bins)
    zeros = Enum.count(bins, fn bin -> Enum.at(bin, pos) == "0" end)

    prefix =
      if zeros > total / 2 do
        prefix ++ ["1"]
      else
        prefix ++ ["0"]
      end

    bins = Enum.filter(bins, &List.starts_with?(&1, prefix))
    co2_filter(bins, prefix)
  end
end
