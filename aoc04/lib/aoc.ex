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

  def parse_board(board) do
    map =
      String.split(board, "\n", trim: true)
      # row
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, row} ->
        String.split(line)
        |> Enum.with_index()
        |> Enum.map(fn {i, col} ->
          {String.to_integer(i), {row, col}}
        end)
      end)
      |> Map.new()

    coords =
      Map.values(map)
      |> Enum.map(&{&1, false})
      |> Map.new()

    {map, coords}
  end

  def parse(text) do
    [nums | boards] = String.split(text, "\n\n", trim: true)

    nums =
      String.split(nums, ",")
      |> Enum.map(&String.to_integer/1)

    boards = Enum.map(boards, &parse_board/1)
    {boards, nums}
  end

  def part1({boards, nums}) do
    Bingo.run(boards, nums)
  end

  def part2({boards, nums}) do
    Bingo.last(boards, nums)
  end
end

defmodule Bingo do
  # a bingo board is two Maps.
  # the first is a map of num -> {r,c}
  # the second is a map of {r,c} -> bool, for the marked
  # status. a board wins if all in row or col is marked
  def run(boards, [i | input]) do
    boards = Enum.map(boards, &mark_board(&1, i))

    case Enum.find(boards, &winner?/1) do
      {map, coords} ->
        s =
          Enum.filter(map, fn {_i, coord} ->
            !Map.fetch!(coords, coord)
          end)
          |> Enum.map(fn {i, _} -> i end)
          |> Enum.sum()

        s * i

      nil ->
        run(boards, input)
    end
  end

  def run(_boards, []) do
    IO.puts("oops no winners")
    -1
  end

  def last(boards, [i | input]) do
    boards = Enum.map(boards, &mark_board(&1, i))
    loser_boards = Enum.filter(boards, &(!winner?(&1)))

    if length(loser_boards) == 0 do
      # last winner
      {map, coords} = List.last(boards)

      s =
        Enum.filter(map, fn {_i, coord} ->
          !Map.fetch!(coords, coord)
        end)
        |> Enum.map(fn {i, _} -> i end)
        |> Enum.sum()

      s * i
    else
      last(loser_boards, input)
    end
  end

  def mark_board({map, coords}, i) do
    case Map.fetch(map, i) do
      {:ok, coord} ->
        {map, Map.replace(coords, coord, true)}

      :error ->
        {map, coords}
    end
  end

  def winner?({_map, coords}) do
    # evaluate all rows and columns for completely 
    # marked board
    row_win =
      Enum.any?(0..4, fn r ->
        Enum.all?(0..4, fn c ->
          Map.fetch!(coords, {r, c})
        end)
      end)

    col_win =
      Enum.any?(0..4, fn c ->
        Enum.all?(0..4, fn r ->
          Map.fetch!(coords, {r, c})
        end)
      end)

    row_win || col_win
  end
end
