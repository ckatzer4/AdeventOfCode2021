defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    text = "inp w
add z w
mod z 2
div w 2
add y w
mod y 2
div w 2
add x w
mod x 2
div w 2
mod w 2"
    cmds = Aoc.parse(text)
    state = Alu.run(cmds, [10])
    assert state["w"] == 1
    assert state["x"] == 0
    assert state["y"] == 1
    assert state["z"] == 0
  end

  test "part1" do
    # text = ""
    # t = Aoc.parse(text)
    # Aoc.part1(t)
    assert true
  end

  test "part2" do
    # text = ""
    # t = Aoc.parse(text)
    # Aoc.part2(t)
    assert true
  end
end
