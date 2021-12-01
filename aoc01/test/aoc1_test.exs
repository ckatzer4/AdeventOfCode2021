defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    text = "199
200
208
210
200
207
240
269
260
263"
    t = Aoc.parse(text)
    assert true
  end

  test "part1" do
    text = "199
200
208
210
200
207
240
269
260
263"
    t = Aoc.parse(text)
    c = Aoc.part1(t)
    assert c == 7
  end

  test "part2" do
    text = ""
    # t = Aoc.parse(text)
    # Aoc.part2(t)
    assert true
  end
end
