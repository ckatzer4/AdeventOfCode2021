defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    # text = ""
    assert true
  end

  test "part1" do
    text = "2199943210
3987894921
9856789892
8767896789
9899965678"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 15
  end

  test "part2" do
    # text = ""
    # t = Aoc.parse(text)
    # Aoc.part2(t)
    assert true
  end
end
