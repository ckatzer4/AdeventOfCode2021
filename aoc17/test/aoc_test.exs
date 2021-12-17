defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    # text = ""
    assert true
  end

  test "part1" do
    text = "target area: x=20..30, y=-10..-5"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 45
  end

  test "part2" do
    text = "target area: x=20..30, y=-10..-5"
    t = Aoc.parse(text)
    assert Aoc.part2(t) == 112
  end
end
