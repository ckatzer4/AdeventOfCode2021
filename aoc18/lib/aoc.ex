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

  def part1([n | nums]) do
    Enum.reduce(nums, n, fn num, sum ->
      Snail.reduce({sum, num})
    end)
    |> Snail.magnitude()
  end

  # stolen:
  # http://www.petecorey.com/blog/2018/11/12/permutations-with-and-without-repetition-in-elixir/
  def with_repetitions([], _k), do: [[]]
  def with_repetitions(_list, 0), do: [[]]

  def with_repetitions(list, k) do
    for head <- list, tail <- with_repetitions(list, k - 1), do: [head | tail]
  end

  def part2(nums) do
    pairs = with_repetitions(nums, 2)

    Enum.map(pairs, fn [a, b] ->
      Snail.magnitude(Snail.reduce({a, b}))
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
      {a, b} -> 3 * magnitude(a) + 2 * magnitude(b)
      a -> a
    end
  end

  def explode(num) do
    elem(_expl(num, 4), 2)
  end

  def _expl({a, b}, i) do
    if i == 0 do
      # reached target depth, split
      {true, a, 0, b}
    else
      case _expl(a, i - 1) do
        {true, l, a, r} ->
          {true, l, {a, addl(b, r)}, 0}

        {false, _, _, _} ->
          case _expl(b, i - 1) do
            {true, l, b, r} ->
              {true, 0, {addr(a, l), b}, r}

            {false, _, _, _} ->
              {false, 0, {a, b}, 0}
          end
      end
    end
  end

  # a should be an int
  def _expl(a, _) do
    {false, 0, a, 0}
  end

  def addr({a, b}, r) do
    {a, addr(b, r)}
  end

  def addr(a, r) do
    a + r
  end

  def addl({a, b}, l) do
    {addl(a, l), b}
  end

  def addl(a, l) do
    a + l
  end

  def split(num) do
    elem(_split(num), 1)
  end

  def _split(num) do
    case num do
      {a, b} ->
        case _split(a) do
          {true, new} ->
            {true, {new, b}}

          {false, _} ->
            case _split(b) do
              {true, new} -> {true, {a, new}}
              {false, _} -> {false, {a, b}}
            end
        end

      a when a > 9 ->
        {true, {floor(a / 2), ceil(a / 2)}}

      a ->
        {false, a}
    end
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
