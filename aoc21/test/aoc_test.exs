defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    # text = ""
    assert true
  end

  test "part1" do
    text = "Player 1 starting position: 4
Player 2 starting position: 8"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 739_785
    assert true
  end

  @tag timeout: :infinity
  test "part2" do
    text = "Player 1 starting position: 4
Player 2 starting position: 8"
    t = Aoc.parse(text)
    assert Aoc.part2(t) == 444_356_092_776_315
  end
end
