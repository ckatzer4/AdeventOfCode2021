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

  def parse(text) do
    # target area: x=20..30, y=-10..-5
    {_, _, x, y} =
      String.trim(text)
      |> String.split([" ", ","], trim: true)
      |> List.to_tuple()

    {_, xmin, xmax} =
      String.split(x, ["=", "."], trim: true)
      |> List.to_tuple()

    {_, ymin, ymax} =
      String.split(y, ["=", "."], trim: true)
      |> List.to_tuple()

    xmin = String.to_integer(xmin)
    xmax = String.to_integer(xmax)
    ymin = String.to_integer(ymin)
    ymax = String.to_integer(ymax)

    {{xmin, xmax}, {ymin, ymax}}
  end

  def part1(area) do
    Sim.max_height(area)
  end

  def part2(area) do
    Sim.all_vel(area)
    |> Enum.count()
  end
end

defmodule Sim do
  def max_height(area) do
    all_vel(area)
    |> Enum.map(&elem(&1,2))
    |> Enum.max()
  end

  def all_vel(area) do
    xvels =
      x_range(area)

    Enum.flat_map(-999..999, fn yvel ->
      Enum.map(xvels, fn xvel ->
        {xvel, yvel, y_max(area, 0, xvel, 0, yvel, 0)}
      end)
      |> Enum.filter(&elem(&1,2)!=nil)
    end)
  end

  def y_max(area, xpos, xvel, ypos, yvel, height) do
    # determine how high we can shoot
    {{_xmin, xmax}, {ymin, _ymax}} = area

    cond do
      in_area?(area, xpos, ypos) ->
        height

      ypos < ymin ->
        # nil indicates we missed or dont make it
        nil

      xpos > xmax ->
        nil

      true ->
        xpos = xpos + xvel
        xvel = if xvel == 0, do: xvel, else: xvel - 1
        ypos = ypos + yvel
        yvel = yvel - 1

        if ypos > height do
          y_max(area, xpos, xvel, ypos, yvel, ypos)
        else
          y_max(area, xpos, xvel, ypos, yvel, height)
        end
    end
  end

  def x_range({{xmin, xmax}, {_, _}}) do
    # determine range of x velocity that gets us
    # to the target. at this point, ignore y
    Enum.filter(1..xmax, fn xvel ->
      x_sim(xmin, xmax, 0, xvel)
    end)
  end

  def x_sim(xmin, xmax, xpos, xvel) do
    cond do
      xpos >= xmin && xpos <= xmax ->
        # we did it
        true

      xpos > xmax ->
        # overshot
        false

      xvel == 0 && xpos < xmin ->
        # undershot due to drag
        false

      true ->
        # step sim
        # we'd step time too, but it doesnt matter here
        x_sim(xmin, xmax, xpos + xvel, xvel - 1)
    end
  end

  def in_area?({{xmin, xmax}, {ymin, ymax}}, x, y) do
    x >= xmin && x <= xmax && y >= ymin && y <= ymax
  end
end
