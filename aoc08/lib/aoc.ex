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

  def parse_line(line) do
    {all_ten, output} =
      String.split(line, " | ")
      |> List.to_tuple()

    {String.split(all_ten), String.split(output)}
  end

  def seg_sort(segments) do
    # need to sort segments to pull from map
    String.graphemes(segments)
    |> Enum.sort()
    |> Enum.join()
  end

  def parse(text) do
    input =
      String.split(text, "\n", trim: true)
      |> Enum.map(&parse_line/1)

    input
  end

  def part1(input) do
    outputs = Enum.map(input, &elem(&1, 1))

    Enum.flat_map(outputs, fn values ->
      Enum.filter(values, fn digit ->
        d = String.length(digit)
        d == 2 || d == 3 || d == 4 || d == 7
      end)
    end)
    |> Enum.count()
  end

  def initial({digits, output}) do
    # find one
    one = Enum.find(digits, &(String.length(&1) == 2))
    digits = List.delete(digits, one)
    # find four
    four = Enum.find(digits, &(String.length(&1) == 4))
    digits = List.delete(digits, four)
    # find seven
    seven = Enum.find(digits, &(String.length(&1) == 3))
    digits = List.delete(digits, seven)
    # find eight
    eight = Enum.find(digits, &(String.length(&1) == 7))
    digits = List.delete(digits, eight)
    decode({digits, output}, %{1 => one, 4 => four, 7 => seven, 8 => eight})
  end

  def decode({digits, output}, map) do
    one =
      Map.fetch!(map, 1)
      |> String.graphemes()
      |> MapSet.new()

    four =
      Map.fetch!(map, 4)
      |> String.graphemes()
      |> MapSet.new()

    seven =
      Map.fetch!(map, 7)
      |> String.graphemes()
      |> MapSet.new()

    eight =
      Map.fetch!(map, 8)
      |> String.graphemes()
      |> MapSet.new()

    # 0,6,9 use 6 segments
    six_seg = Enum.filter(digits, &(String.length(&1) == 6))

    # 2,3,5 use 5 segments
    fiv_seg = Enum.filter(digits, &(String.length(&1) == 5))

    # for 6 seg nums, diff between 8,1,4 can tell us num
    # 6-seg whose missing seg from 8 is in 1 is 6
    # the next with missing seg from 8 in 4 is 0
    # the final must be 9
    six =
      Enum.find(six_seg, fn test ->
        test =
          String.graphemes(test)
          |> MapSet.new()

        diff8 = MapSet.difference(eight, test)
        MapSet.subset?(diff8, one)
      end)

    six_seg = List.delete(six_seg, six)

    zero =
      Enum.find(six_seg, fn test ->
        test =
          String.graphemes(test)
          |> MapSet.new()

        diff8 = MapSet.difference(eight, test)
        MapSet.subset?(diff8, four)
      end)

    six_seg = List.delete(six_seg, zero)
    [nine] = six_seg
    map = Map.merge(map, %{6 => six, 0 => zero, 9 => nine})

    # for 5-seg, one containing all segs from 7 is 3
    # the one with all segs within 9 is 5
    # leaving 2
    three =
      Enum.find(fiv_seg, fn test ->
        test =
          String.graphemes(test)
          |> MapSet.new()

        MapSet.subset?(seven, test)
      end)

    fiv_seg = List.delete(fiv_seg, three)

    five =
      Enum.find(fiv_seg, fn test ->
        test =
          String.graphemes(test)
          |> MapSet.new()

        nine =
          String.graphemes(nine)
          |> MapSet.new()

        MapSet.subset?(test, nine)
      end)

    fiv_seg = List.delete(fiv_seg, five)
    [two] = fiv_seg
    map = Map.merge(map, %{3 => three, 5 => five, 2 => two})

    map =
      Enum.map(map, fn {k, v} -> {seg_sort(v), k} end)
      |> Map.new()

    final(output, map)
  end

  def final(output, digit_map) do
    Enum.map(output, &seg_sort/1)
    |> Enum.map(&Map.fetch!(digit_map, &1))
    |> Enum.join()
    |> String.to_integer()
  end

  def part2(input) do
    Enum.map(input, &initial/1)
    |> Enum.sum()
  end
end
