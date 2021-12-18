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
    nums =
      String.split(text, "\n", trim: true)
      |> Enum.map(&Snail.parse/1)

    nums
  end

  def part1([n|nums]) do
    Enum.reduce(nums, n, fn num, sum ->
      Snail.reduce({sum, num})
    end)
    |> Snail.magnitude()
  end

  def with_repetitions([], _k), do: [[]]
  def with_repetitions(_list, 0), do: [[]]
  def with_repetitions(list, k) do
    for head <- list, tail <- with_repetitions(list, k - 1), do: [head | tail]
  end

  def part2(nums) do
    pairs = with_repetitions(nums, 2)
    Enum.flat_map(pairs, fn [a,b] ->
      [
        Snail.magnitude(Snail.reduce({a,b})),
        Snail.magnitude(Snail.reduce({b,a})),
      ]
    end)
    |> Enum.max()
  end
end

defmodule Snail do
  # parse a line and return a nested tuple
  # super fudging dangerous eval
  def parse(line) do
    line
    |> String.replace("[", "{")
    |> String.replace("]", "}")
    |> Code.eval_string([])
    |> elem(0)
  end

  def reduce(num) do
    cond do
      nested_level(num) > 4 ->
        explode(num)
        |> reduce()

      max_int(num) > 9 ->
        split(num)
        |> reduce()

      true ->
        num
    end
  end

  def magnitude(num) do
    case num do
      {a,b} -> 3*magnitude(a)+2*magnitude(b)
      a -> a
    end
  end

  def all_coords(num, co) do
    case num do
      {a, b} ->
        all_coords(a, [0 | co]) ++ all_coords(b, [1 | co])

      _ ->
        [Enum.reverse(co)]
    end
  end

  def find(num, []) do
    num
  end

  def find(num, [i | co]) do
    find(elem(num, i), co)
  end

  def reconstruct(index, digits) do
    i_d = Enum.zip(index, digits)
    zeros = Enum.filter(i_d, fn {i, _} -> hd(i) == 0 end)
    ones = Enum.filter(i_d, fn {i, _} -> hd(i) == 1 end)
    {_rec(zeros), _rec(ones)}
  end

  def _rec([{_i, d}]) do
    d
  end

  def _rec(i_d) do
    # pop the common digit off and loop again
    i_d = Enum.map(i_d, fn {i, d} -> {tl(i), d} end)
    zeros = Enum.filter(i_d, fn {i, _} -> hd(i) == 0 end)
    ones = Enum.filter(i_d, fn {i, _} -> hd(i) == 1 end)
    {_rec(zeros), _rec(ones)}
  end

  def explode(num) do
    ind = all_coords(num, [])
    dig = Enum.map(ind, &find(num, &1))
    l = Enum.find_index(ind, &(length(&1) > 4))
    {li, ind} = List.pop_at(ind, l)
    li = List.delete_at(li, -1)
    ind = List.replace_at(ind, l, li)

    dig =
      cond do
        # leftmost side
        l == 0 ->
          # lost
          {_, dig} = List.pop_at(dig, l)
          rd = Enum.at(dig, l)

          List.replace_at(dig, l, 0)
          |> List.update_at(l + 1, &(&1 + rd))

        # rightmost
        l + 1 == length(ind) ->
          {ld, dig} = List.pop_at(dig, l)
          dig = List.update_at(dig, l - 1, &(&1 + ld))
          # lost
          List.replace_at(dig, l, 0)

        true ->
          {ld, dig} = List.pop_at(dig, l)
          dig = List.update_at(dig, l - 1, &(&1 + ld))
          rd = Enum.at(dig, l)

          List.replace_at(dig, l, 0)
          |> List.update_at(l + 1, &(&1 + rd))
      end

    reconstruct(ind, dig)
  end

  def split(num) do
    ind = all_coords(num, [])
    dig = Enum.map(ind, &find(num, &1))
    m = Enum.find_index(dig, &(&1>9))
    mi = Enum.at(ind, m)
    md = Enum.at(dig, m)
    left = floor(md/2)
    right = ceil(md/2)
    li = mi ++ [0]
    ri = mi ++ [1]

    ind = List.replace_at(ind, m, li)
    |> List.insert_at(m+1, ri)

    dig = List.replace_at(dig, m, left)
    |> List.insert_at(m+1, right)

    reconstruct(ind, dig)
  end

  def nested_level(num) do
    nested_level(num, 0, 0)
  end

  def nested_level(num, depth, max) do
    max = if depth > max, do: depth, else: max

    case num do
      {a, b} ->
        a = nested_level(a, depth + 1, max)
        b = nested_level(b, depth + 1, max)
        if a > b, do: a, else: b

      _ ->
        max
    end
  end

  def max_int(num) do
    case num do
      {a, b} ->
        a = max_int(a)
        b = max_int(b)
        if a > b, do: a, else: b

      a ->
        a
    end
  end
end
