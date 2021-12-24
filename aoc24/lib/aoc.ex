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
    [cmd | par] = String.split(line)
    cmd = String.to_atom(cmd)

    par =
      Enum.map(par, fn p ->
        case Integer.parse(p) do
          {i, ""} -> i
          :error -> p
        end
      end)

    {cmd, par}
  end

  def parse(text) do
    cmds =
      String.split(text, "\n", trim: true)
      |> Enum.map(&parse_line/1)

    cmds
  end

  def qvalid?(monad) do
    # another "pen-and-paper" day :)
    # reverse-engineered the input program.
    # in effect, the input uses z as a stack:
    # - add a to digit and push on stack (e.g. z*26)
    # - pop off stack, subtract b, and compare to digit
    # a valid MONAD is one where all comparisons are true
    # by identifying the order of push/pop and values of
    # a and b, we get the following comparisons:
    [a,b,c,d,e,f,g,h,i,j,k,l,m,n] = monad
    d == e+3 &&
    f == g+8 &&
    i == h+7 &&
    c == j+1 &&
    l == k+8 &&
    b == m+6 &&
    n == a+4
  end

  def valid?(monad, cmds) do
    Alu.run(cmds, monad)
    |> Map.fetch!("z")
    |> then(&(&1 == 0))
  end

  def part1(cmds) do
    # testing trillions of numbers is slow
    # 11_111_111_111_111..99_999_999_999_999
    # referencing qvalid?, pick the biggest numbers
    [59_996_912_981_939]
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(&Enum.all?(&1, fn d -> d != 0 end))
    |> Stream.filter(&valid?(&1,cmds))
    |> Stream.map(&Integer.undigits/1)
    |> Enum.max()
  end

  def part2(cmds) do
    # same as part1, but smallest instead
    [17_241_911_811_915]
    |> Stream.map(&Integer.digits/1)
    |> Stream.filter(&Enum.all?(&1, fn d -> d != 0 end))
    |> Stream.filter(&valid?(&1,cmds))
    |> Stream.map(&Integer.undigits/1)
    |> Enum.max()
  end
end

defmodule Alu do
  @init_state %{"w" => 0, "x" => 0, "y" => 0, "z" => 0}
  def run(cmds, input) do
    step(cmds, @init_state, input)
  end

  def printz(z) do
    z0 = rem(z,26)
    z = floor(z/26)
    z1 = rem(z,26)
    z = floor(z/26)
    z2 = rem(z,26)
    z = floor(z/26)
    z3 = rem(z,26)
    z = floor(z/26)
    z4 = rem(z,26)
    z = floor(z/26)
    z5 = rem(z,26)
    z = floor(z/26)
    z6 = rem(z,26)
    IO.inspect({z6,z5,z4,z3,z2,z1,z0})
  end

  def step([], state, _), do: state

  def step([cmd | cmds], state, input) do
    # IO.inspect({cmd, state, input})
    # printz(state["z"])

    case cmd do
      {:inp, [var]} ->
        state = Map.put(state, var, hd(input))
        step(cmds, state, tl(input))

      {:add, [var0, i]} when is_integer(i) ->
        state = Map.update!(state, var0, &(&1 + i))
        step(cmds, state, input)

      {:add, [var0, var1]} ->
        i = state[var1]
        state = Map.update!(state, var0, &(&1 + i))
        step(cmds, state, input)

      {:mul, [var0, i]} when is_integer(i) ->
        state = Map.update!(state, var0, &(&1 * i))
        step(cmds, state, input)

      {:mul, [var0, var1]} ->
        i = state[var1]
        state = Map.update!(state, var0, &(&1 * i))
        step(cmds, state, input)

      {:div, [var0, i]} when is_integer(i) ->
        state = Map.update!(state, var0, &floor(&1 / i))
        step(cmds, state, input)

      {:div, [var0, var1]} ->
        i = state[var1]
        state = Map.update!(state, var0, &floor(&1 / i))
        step(cmds, state, input)

      {:mod, [var0, i]} when is_integer(i) ->
        state = Map.update!(state, var0, &rem(&1, i))
        step(cmds, state, input)

      {:mod, [var0, var1]} ->
        i = state[var1]
        state = Map.update!(state, var0, &rem(&1, i))
        step(cmds, state, input)

      {:eql, [var0, i]} when is_integer(i) ->
        res = if state[var0] == i, do: 1, else: 0
        state = Map.put(state, var0, res)
        step(cmds, state, input)

      {:eql, [var0, var1]} ->
        i = state[var1]
        res = if state[var0] == i, do: 1, else: 0
        state = Map.put(state, var0, res)
        step(cmds, state, input)
    end
  end
end
