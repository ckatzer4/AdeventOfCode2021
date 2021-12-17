defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  test "parse input" do
    text = "D2FE28"

    Aoc.parse(text)
    |> BITS.parse()
    # |> IO.inspect()

    text = "38006F45291200"

    Aoc.parse(text)
    |> BITS.parse()
    # |> IO.inspect()

    text = "EE00D40C823060"

    Aoc.parse(text)
    |> BITS.parse()
    # |> IO.inspect()

    text = "A0016C880162017C3686B18A3D4780"

    Aoc.parse(text)
    |> BITS.parse()
    # |> IO.inspect()

    assert true
  end

  test "part1" do
    text = "A0016C880162017C3686B18A3D4780"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 31
    text = "620080001611562C8802118E34"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 12
    text = "C0015000016115A2E0802F182340"
    t = Aoc.parse(text)
    assert Aoc.part1(t) == 23
  end

  test "part2" do
    # text = ""
    # t = Aoc.parse(text)
    # Aoc.part2(t)
    assert true
  end
end
