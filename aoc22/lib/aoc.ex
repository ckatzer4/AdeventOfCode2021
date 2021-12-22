defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc.hello()
      :world

  """
  def hello do
    :world
  end

  def parse_line(line) do
    # on x=-39..5,y=-35..13,z=-14..36
    [toggle | xyz] = String.split(line, [" ", ","])

    {x, y, z} =
      Enum.map(xyz, fn s ->
        {_, min, max} =
          String.split(s, ["=", "."], trim: true)
          |> List.to_tuple()

        {String.to_integer(min), String.to_integer(max)}
      end)
      |> List.to_tuple()

    {String.to_atom(toggle), x, y, z}
  end

  def parse(text) do
    ins =
      String.split(text, "\n", trim: true)
      |> Enum.map(&parse_line/1)

    ins
  end

  def part1(ins) do
    boot =
      Enum.filter(ins, fn {_, {xmin, xmax}, _, _} ->
        !(xmin < -50 || xmax > 50)
      end)

    for {i, {x1, x2}, {y1, y2}, {z1, z2}} <- boot, reduce: MapSet.new() do
      cubes ->
        for x <- x1..x2, y <- y1..y2, z <- z1..z2, reduce: cubes do
          cubes ->
            case i do
              :on -> MapSet.put(cubes, {x, y, z})
              :off -> MapSet.delete(cubes, {x, y, z})
            end
        end
    end
    |> MapSet.size()
  end

  def part2(ins) do
    Cubes.run(ins)
  end
end

defmodule Cubes do
  def run(ins) do
    run(ins, [])
  end

  def run([], cubes) do
    Enum.reduce(cubes, 0, fn cube, vol ->
      case cube do
        {:on, _, _, _} -> vol + volume(cube)
        {:off, _, _, _} -> vol - volume(cube)
      end
    end)
  end

  def run([cube | ins], cubes) do
    # make opposite cubes for all overlaps
    duplicates =
      Enum.filter(cubes, &intersects?(&1, cube))
      |> Enum.map(&intersect_cube(&1, cube))
    if match?({:on, _,_,_}, cube) do
      run(ins, [cube | duplicates] ++ cubes)
    else
      run(ins, duplicates ++ cubes)
    end
  end

  def intersect_cube(cube1, cube2) do
    {toggle, {x1, x2}, {y1, y2}, {z1, z2}} = cube1
    {_, {i1, i2}, {j1, j2}, {k1, k2}} = cube2

    xr = range_intersect({x1, x2}, {i1, i2})
    yr = range_intersect({y1, y2}, {j1, j2})
    zr = range_intersect({z1, z2}, {k1, k2})

    if toggle == :on do
      {:off, xr, yr, zr}
    else
      {:on, xr, yr, zr}
    end
  end

  def range_intersect({x1, x2}, {i1, i2}) do
    cond do
      x1 <= i1 && i2 <= x2 -> {i1, i2}
      i1 <= x1 && x2 <= i2 -> {x1, x2}
      x1 <= i1 && x2 <= i2 -> {i1, x2}
      i1 <= x1 && i2 <= x2 -> {x1, i2}
    end
  end

  def intersects?(cube1, cube2) do
    {_, {x1, x2}, {y1, y2}, {z1, z2}} = cube1
    {_, {i1, i2}, {j1, j2}, {k1, k2}} = cube2

    !Range.disjoint?(x1..x2, i1..i2) &&
      !Range.disjoint?(y1..y2, j1..j2) &&
      !Range.disjoint?(z1..z2, k1..k2)
  end

  def volume({_, {x1, x2}, {y1, y2}, {z1, z2}}) do
    # add 1 to each dimension, in the case x1==x2
    abs(1 + x2 - x1) * abs(1 + y2 - y1) * abs(1 + z2 - z1)
  end
end
