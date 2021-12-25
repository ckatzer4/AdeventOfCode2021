defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    # text = ""
    assert true
  end

  test "part1" do
    text = "v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>"

    t = Aoc.parse(text)

    assert Aoc.part1(t) == 58
    assert true
  end

  test "part2" do
    # text = ""
    # t = Aoc.parse(text)
    # Aoc.part2(t)
    assert true
  end
end
