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

  def parse_line({line, r}) do
    String.graphemes(line)
    |> Enum.with_index()
    |> Enum.filter(&(elem(&1, 0) != "."))
    |> Enum.map(fn {g, c} -> {{r, c}, g} end)
  end

  def parse(text) do
    map =
      String.split(text, "\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(&parse_line/1)
      |> Map.new()

    map
  end

  def part1(map) do
    rmax = Map.keys(map) |> Enum.map(&elem(&1, 0)) |> Enum.max()
    cmax = Map.keys(map) |> Enum.map(&elem(&1, 1)) |> Enum.max()
    Cucumber.run(map, {rmax, cmax}, 0)
  end

  def part2(map) do
  end
end

defmodule Cucumber do
  def run(map, {rmax, cmax}, count) do
    # IO.inspect({"==", count, "=="})
    # printmap(map, {rmax, cmax})
    new = step(map, {rmax, cmax})

    if new == map do
      count + 1
    else
      run(new, {rmax, cmax}, count + 1)
    end
  end

  def step(map, {rmax, cmax}) do
    # east first, then south
    next =
      Enum.map(map, fn {{r, c}, g} ->
        case g do
          ">" ->
            target =
              if c == cmax do
                # wrap
                {r, 0}
              else
                {r, c + 1}
              end

            if Map.get(map, target, ".") == "." do
              {target, g}
            else
              {{r, c}, g}
            end

          g ->
            {{r, c}, g}
        end
      end)
      |> Map.new()

    next =
      Enum.map(next, fn {{r, c}, g} ->
        case g do
          "v" ->
            target =
              if r == rmax do
                # wrap
                {0, c}
              else
                {r + 1, c}
              end

            if Map.get(next, target, ".") == "." do
              {target, g}
            else
              {{r, c}, g}
            end

          g ->
            {{r, c}, g}
        end
      end)
      |> Map.new()

    next
  end

  def printmap(map, {rmax, cmax}) do
    Enum.map(0..rmax, fn r ->
      Enum.map(0..cmax, fn c -> Map.get(map, {r, c}, ".") end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
