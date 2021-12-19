defmodule Mix.Tasks.Aoc.UniqRotations do
  @moduledoc """
  Hiding some code in here to improve my line count.
  I used this helper script to filter down my rotation
  logic to just the necessary 24.
  """
  use Mix.Task

  def run(_) do
    calc_uniq_rotations()
    |> IO.inspect()
   end

  def calc_uniq_rotations() do
    all_rotations()
    |> Enum.map(fn [x, y, z] ->
      mmult(x, y)
      |> mmult(z)
    end)
    |> Enum.uniq()
  end

  def all_rotations() do
    for x <- xrotations(),
        y <- yrotations(),
        z <- zrotations(),
        do: [x, y, z]
  end

  def mmult([[a1, b1, c1], [d1, e1, f1], [g1, h1, i1]], [[a2, b2, c2], [d2, e2, f2], [g2, h2, i2]]) do
    # I'm sorry
    [
      [a1 * a2 + b1 * d2 + c1 * g2, a1 * b2 + b1 * e2 + c1 * h2, a1 * c2 + b1 * f2 + c1 * i2],
      [d1 * a2 + e1 * d2 + f1 * g2, d1 * b2 + e1 * e2 + f1 * h2, d1 * c2 + e1 * f2 + f1 * i2],
      [g1 * a2 + h1 * d2 + i1 * g2, g1 * b2 + h1 * e2 + i1 * h2, g1 * c2 + h1 * f2 + i1 * i2]
    ]
  end

  def xrotations() do
    [
      [
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 1]
      ],
      [
        [1, 0, 0],
        [0, 0, -1],
        [0, 1, 0]
      ],
      [
        [1, 0, 0],
        [0, -1, 0],
        [0, 0, -1]
      ],
      [
        [1, 0, 0],
        [0, 0, 1],
        [0, -1, 0]
      ]
    ]
  end

  def yrotations() do
    [
      [
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 1]
      ],
      [
        [0, 0, 1],
        [0, 1, 0],
        [-1, 0, 0]
      ],
      [
        [-1, 0, 0],
        [0, 1, 0],
        [0, 0, -1]
      ],
      [
        [0, 0, -1],                                             [0, 1, 0],
        [1, 0, 0]                                             ]
    ]
  end                                                   
  def zrotations() do
    [
      [
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 1]
      ],                                                      [
        [0, -1, 0],
        [1, 0, 0],                                              [0, 0, 1]
      ],
      [
        [-1, 0, 0],                                             [0, -1, 0],                                             [0, 0, 1]                                             ],                                                      [                                                         [0, 1, 0],                                              [-1, 0, 0],                                             [0, 0, 1]                                             ]
    ]
  end
end
