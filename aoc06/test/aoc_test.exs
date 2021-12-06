defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    # text = ""
    assert true
  end

  test "part1" do
    text = "3,4,3,1,2"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 5934
  end

  test "part2" do
    text = "3,4,3,1,2"
    t = Aoc.parse(text)
    assert Aoc.part2(t) == 26_984_457_539
  end
end
