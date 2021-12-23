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

  def parse(_text) do
    # im not parsing today
    {["D", "C"], ["A", "C"], ["A", "B"], ["D", "B"]}
  end

  def part1(rooms) do
    Pods.cost(rooms, %{}, 0, 2)
  end

  def part2(_) do
    {
      ["D", "D", "D", "C"],
      ["A", "C", "B", "C"],
      ["A", "B", "A", "B"],
      ["D", "A", "C", "B"]
    }
    |> Pods.cost(%{}, 0, 4)
  end
end

defmodule Pods do
  use Memoize
  @podcosts %{"A" => 1, "B" => 10, "C" => 100, "D" => 1000}
  @dest %{"A" => 0, "B" => 1, "C" => 2, "D" => 3}
  # there are seven hallway spots and 4 rooms, each with
  # 2 spots. Hallway spot 0 (hs0), is blocked by hs1.
  # hs3 blocks the connections between rooms 0 & 1, as
  # does hs5 for 1&2 and hs7 for 2&3. hs9 blocks hs10.
  # Graph: hs0-hs1-r0-hs3-r1-hs5-r2-hs7-r3-hs9-hs10
  # step(rooms, hallway)
  defmemo cost(rooms, hall, total, rl) do
    if done?(rooms, rl) do
      total
    else
      p = possible(rooms, hall, rl)

      if p == [] do
        999_999_999_999_999
      else
        Enum.map(p, fn {r, h, c} ->
          cost(r, h, total + c, rl)
        end)
        |> Enum.min()
      end
    end
  end

  def done?(rooms,rl) do
    Tuple.to_list(rooms)
    |> Enum.with_index()
    |> Enum.all?(fn {room,i} ->
      length(room)==rl && Enum.all?(room, &(@dest[&1] == i))
    end)
  end

  def possible(rooms, hall, rl) do
    # head of rooms can move to empty hall spots if
    # theyre room isnt done
    r_to_h =
      [0, 1, 2, 3]
      |> Enum.filter(fn i ->
        room = elem(rooms, i)

        case room do
          [a, a, a, a] -> !(@dest[a] == i)
          [_, _, _, _] -> true
          [a, a, a] -> !(@dest[a] == i)
          [_, _, _] -> true
          [a, a] -> !(@dest[a] == i)
          [_, _] -> true
          [a] -> !(@dest[a] == i)
          [] -> false
        end
      end)
      |> Enum.flat_map(fn i ->
        for h <- [0, 1, 3, 5, 7, 9, 10], !Map.has_key?(hall, h) do
          {{:r, i}, {:h, h}}
        end
      end)
      |> Enum.filter(fn {r, h} -> path_to?(r, h, rooms, hall) end)
      |> Enum.map(fn {{:r, i}, {:h, h}} ->
        [pod | new] = elem(rooms, i)
        cost = moves({:r, i}, {:h, h}, rooms,rl) * @podcosts[pod]
        rooms = put_elem(rooms, i, new)
        {rooms, Map.put(hall, h, pod), cost}
      end)

    # spots in hall can move to room of their choice if
    # there is an open path
    h_to_r =
      [0, 1, 3, 5, 7, 9, 10]
      |> Enum.flat_map(fn i ->
        case Map.fetch(hall, i) do
          {:ok, pod} ->
            d = @dest[pod]

            if path_to?({:h, i}, {:r, d}, rooms, hall) do
              cost = moves({:h, i}, {:r, d}, rooms,rl) * @podcosts[pod]
              before = elem(rooms, d)
              new = put_elem(rooms, d, [pod | before])
              [{new, Map.delete(hall, i), cost}]
            else
              []
            end

          :error ->
            []
        end
      end)

    r_to_h ++ h_to_r
  end

  def path_to?({:r, i}, {:h, c}, _rooms, hall) do
    # check for anything in the hallway
    rc = 2 * i + 2
    Enum.all?(rc..c, &(!Map.has_key?(hall, &1)))
  end

  def path_to?({:h, c}, {:r, i}, rooms, hall) do
    rc = 2 * i + 2
    hall_clear = Enum.all?(rc..c, &(!Map.has_key?(hall, &1)||&1==c))
    # dont go into room with the wrong pods
    room = elem(rooms, i)
    room_ready = Enum.all?(room, &(i == @dest[&1]))
    hall_clear && room_ready
  end

  def moves(from, dest, rooms, rl) do
    case {from, dest} do
      {{:h, c}, {:r, i}} ->
        # extra cost for far hallways and empty rooms
        rm = rl-length(elem(rooms, i))
        abs(2 * i + 2 - c) + rm

      {{:r, i}, {:h, c}} ->
        rm = rl-length(elem(rooms, i))+1
        abs(2 * i + 2 - c) + rm
    end
  end
end
