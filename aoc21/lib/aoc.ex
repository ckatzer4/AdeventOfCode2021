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
    [p1, p2] = String.split(text, "\n", trim: true)

    [_, p1] = String.split(p1, ": ")
    [_, p2] = String.split(p2, ": ")

    {String.to_integer(p1), String.to_integer(p2)}
  end

  def round(rolls, count, place, score) do
    {count, place} =
      Enum.reduce(rolls, {count, place}, fn die, {count, place} ->
        place = rem(place - 1 + die, 10) + 1
        count = count + 1

        {count, place}
      end)

    score = score + place

    if score >= 1000 do
      {:halt, {count, place, score}}
    else
      {:cont, {count, place, score}}
    end
  end

  def part1({p1, p2}) do
    {count, _p1, s1, _p2, s2} =
      Stream.cycle(1..100)
      |> Stream.chunk_every(3)
      |> Enum.reduce_while({0, p1, 0, p2, 0}, fn rolls, game ->
        {count, p1, s1, p2, s2} = game
        p_turn = rem(count, 6)

        if p_turn < 3 do
          {cont, {count, p1, s1}} = round(rolls, count, p1, s1)
          {cont, {count, p1, s1, p2, s2}}
        else
          {cont, {count, p2, s2}} = round(rolls, count, p2, s2)
          {cont, {count, p1, s1, p2, s2}}
        end
      end)

    if s1 > s2 do
      count * s2
    else
      count * s1
    end
  end

  # original brute force solution
  # see Dirac module below of memoized solution
  def dirac(p1turn, p1, s1, p2, s2) do
    Enum.zip([1, 3, 6, 7, 6, 3, 1], 3..9)
    |> Enum.reduce({0, 0}, fn {uc, dsum}, {t1, t2} ->
      {w1, w2} = dirac(p1turn, p1, s1, p2, s2, dsum)
      {t1 + uc * w1, t2 + uc * w2}
    end)
  end

  def dirac(p1turn, p1, s1, p2, s2, sum) do
    if p1turn do
      # player 1
      p1 = rem(p1 - 1 + sum, 10) + 1
      s1 = s1 - p1

      if s1 < 1 do
        {1, 0}
      else
        Enum.zip([1, 3, 6, 7, 6, 3, 1], 3..9)
        |> Enum.reduce({0, 0}, fn {uc, dsum}, {t1, t2} ->
          {w1, w2} = dirac(false, p1, s1, p2, s2, dsum)
          {t1 + uc * w1, t2 + uc * w2}
        end)
      end
    else
      p2 = rem(p2 - 1 + sum, 10) + 1
      s2 = s2 - p2

      if s2 < 1 do
        {0, 1}
      else
        Enum.zip([1, 3, 6, 7, 6, 3, 1], 3..9)
        |> Enum.reduce({0, 0}, fn {uc, dsum}, {t1, t2} ->
          {w1, w2} = dirac(true, p1, s1, p2, s2, dsum)
          {t1 + uc * w1, t2 + uc * w2}
        end)
      end
    end
  end

  def part2({p1, p2}) do
    # {s1, s2} = dirac(true, p1, 21, p2, 21)
    {s1, s2} = Dirac.dirac(p1, 21, p2, 21)

    if s1 > s2 do
      s1
    else
      s2
    end
  end
end

defmodule Dirac do
  use Memoize

  defmemo dirac(p1, s1, p2, s2) do
    cond do
      s1 < 1 ->
        {1, 0}

      s2 < 1 ->
        {0, 1}

      true ->
        Enum.zip([1, 3, 6, 7, 6, 3, 1], 3..9)
        |> Enum.reduce({0, 0}, fn {uc, dsum}, {t1, t2} ->
          p1 = rem(p1 - 1 + dsum, 10) + 1
          s1 = s1 - p1
          # swap players and swap results
          {w1, w2} = dirac(p2, s2, p1, s1)
          {t1 + uc * w2, t2 + uc * w1}
        end)
    end
  end
end
