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

  def parse_scanner(text) do
    [scanner | beacons] = String.split(text, "\n", trim: true)

    scanner =
      String.split(scanner)
      |> Enum.at(2)
      |> String.to_integer()

    beacons =
      Enum.map(beacons, fn line ->
        String.split(line, ",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    {scanner, beacons}
  end

  def parse(text) do
    scanners =
      String.split(text, "\n\n", trim: true)
      |> Enum.map(&parse_scanner/1)

    Scans.find_overlap(scanners)
  end

  def part1({beacons, _}) do
    MapSet.size(beacons)
  end

  def part2({_, scanners}) do
    Scans.pairs(scanners, scanners)
    |> Enum.map(fn {s1, s2} ->
      {x, y, z} = Scans.sub3(s1, s2)
      abs(x) + abs(y) + abs(z)
    end)
    |> Enum.max()
  end
end

defmodule Scans do
  def find_overlap([{_sid0, bcn0} | scanners]) do
    # s0 is our reference scanner
    beacons = MapSet.new(bcn0)
    find_overlap(scanners, beacons, [{0, 0, 0}])
  end

  def find_overlap([{sid, bcn} | scanners], beacons, shifts) do
    case try_rotations(beacons, bcn, uniq_rotations()) do
      {true, rotxyz, shift} ->
        # IO.inspect({"match", sid, rotxyz, shift})
        # found an overlap, transform and add to beacons
        oriented = Enum.map(bcn, &mapply(&1, rotxyz))
          |> Enum.map(&sub3(&1, shift))
          |> MapSet.new()

        beacons = MapSet.union(beacons, oriented)
        find_overlap(scanners, beacons, [shift | shifts])

      {false, _, _} ->
        # IO.inspect({"nomatch", sid})
        # not the most performant, but probably also not
        # the bottleneck
        List.insert_at(scanners, -1, {sid, bcn})
        |> find_overlap(beacons, shifts)
    end
  end

  def find_overlap([], beacons, shifts) do
    {beacons, shifts}
  end

  def try_rotations(_beacons, _bcn, []) do
    {false, nil, nil}
  end

  def try_rotations(beacons, bcn, [rotxyz | all]) do
    case try_overlaps(beacons, bcn, rotxyz) do
      {true, shift} -> {true, rotxyz, shift}
      {false, _} -> try_rotations(beacons, bcn, all)
    end
  end

  def try_overlaps(beacons, bcn2, rotxyz) do
    # try a rotation on bcn2
    rot = Enum.map(bcn2, &mapply(&1, rotxyz))
    overlap?(beacons, rot, pairs(beacons, rot))
  end

  def overlap?(_bcn1, _bcn2, []) do
    {false, nil}
  end

  def overlap?(bcn1, bcn2, [{b1, b2}|pairs]) do
    # for each beacon pair try:
    #   measure shift
    #   apply shift to all of bcn2
    #   if >=12 in common: we have overlap, return shift
    shift = sub3(b2, b1)

    shifted =
      Enum.map(bcn2, &sub3(&1, shift))
      |> MapSet.new()

    common =
      MapSet.new(bcn1)
      |> MapSet.intersection(shifted)
      |> MapSet.size()

    if common >= 12 do
      {true, shift}
    else
      overlap?(bcn1, bcn2, pairs)
    end
  end

  def sub3({a, b, c}, {x, y, z}) do
    {a - x, b - y, c - z}
  end

  def pairs(a, b) do
    for a <- a,
        b <- b,
        do: {a, b}
  end

  def uniq_rotations() do
    [
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
      [[0, -1, 0], [1, 0, 0], [0, 0, 1]],
      [[-1, 0, 0], [0, -1, 0], [0, 0, 1]],
      [[0, 1, 0], [-1, 0, 0], [0, 0, 1]],
      [[0, 0, 1], [0, 1, 0], [-1, 0, 0]],
      [[0, 0, 1], [1, 0, 0], [0, 1, 0]],
      [[0, 0, 1], [0, -1, 0], [1, 0, 0]],
      [[0, 0, 1], [-1, 0, 0], [0, -1, 0]],
      [[-1, 0, 0], [0, 1, 0], [0, 0, -1]],
      [[0, 1, 0], [1, 0, 0], [0, 0, -1]],
      [[1, 0, 0], [0, -1, 0], [0, 0, -1]],
      [[0, -1, 0], [-1, 0, 0], [0, 0, -1]],
      [[0, 0, -1], [0, 1, 0], [1, 0, 0]],
      [[0, 0, -1], [1, 0, 0], [0, -1, 0]],
      [[0, 0, -1], [0, -1, 0], [-1, 0, 0]],
      [[0, 0, -1], [-1, 0, 0], [0, 1, 0]],
      [[1, 0, 0], [0, 0, -1], [0, 1, 0]],
      [[0, -1, 0], [0, 0, -1], [1, 0, 0]],
      [[-1, 0, 0], [0, 0, -1], [0, -1, 0]],
      [[0, 1, 0], [0, 0, -1], [-1, 0, 0]],
      [[-1, 0, 0], [0, 0, 1], [0, 1, 0]],
      [[0, 1, 0], [0, 0, 1], [1, 0, 0]],
      [[1, 0, 0], [0, 0, 1], [0, -1, 0]],
      [[0, -1, 0], [0, 0, 1], [-1, 0, 0]]
    ]
  end

  def mapply(c, [row1, row2, row3]) do
    {row(row1, c), row(row2, c), row(row3, c)}
  end

  def row([a, b, c], {x, y, z}) do
    a * x + b * y + c * z
  end

end
