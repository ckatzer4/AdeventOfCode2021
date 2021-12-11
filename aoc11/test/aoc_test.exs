defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    # text = ""
    assert true
  end

  test "part1" do
    text = "5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 1656
  end

  test "part2" do
    text = "5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"
    t = Aoc.parse(text)
    assert Aoc.part2(t) == 195
  end
end
