defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    # text = ""
    assert true
  end

  test "part1" do
    text = "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 40
  end

  test "part2" do
    text = "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"
    t = Aoc.parse(text)
    assert Aoc.part2(t) == 315
  end
end
