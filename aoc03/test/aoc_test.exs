defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    # text = ""
    assert true
  end

  test "part1" do
    text = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 198
  end

  test "part2" do
    text = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"
    t = Aoc.parse(text)
    assert Aoc.part2(t) == 230
  end
end
