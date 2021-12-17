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
    bits =
      String.split(text, "\n", trim: true)
      |> hd()
      |> String.graphemes()
      |> Enum.map(&String.to_integer(&1, 16))
      |> Enum.map(&Integer.to_string(&1, 2))
      |> Enum.map(fn s ->
        case String.length(s) do
          1 -> "000" <> s
          2 -> "00" <> s
          3 -> "0" <> s
          4 -> s
        end
      end)
      |> Enum.join()

    bits
  end

  def part1(bits) do
    # walk the packet and sum ver numbers
    pkt = BITS.parse(bits)
    versum(hd(pkt))
  end

  def versum(pkt) do
    case pkt do
      {ver, _, {:op, subs}} ->
        sum = Enum.map(subs, &versum/1)
        |> Enum.sum()
        ver + sum

      {ver, _, {:lit, _}} ->
        ver
    end
  end

  def part2(bits) do
    pkt = BITS.parse(bits)
    BITS.val(hd(pkt))
  end
end

defmodule BITS do
  def parse(bits) do
    parse(bits, [])
  end

  def parse("", packets) do
    packets
  end

  def parse(bits, packets) do
    case parse_one(bits) do
      {:end, _bits} ->
        parse("", packets)

      {{ver, typ, pkt}, bits} ->
        parse(bits, [{ver, typ, pkt} | packets])
    end
  end

  def parse_one(bits) do
    if !String.contains?(bits, "1") do
      {:end, bits}
    else
      case version_and_type(bits) do
        {:ok, {ver, typ, bits}} ->
          {pkt, bits} =
            case typ do
              4 -> take_literal(bits)
              _ -> take_operator(bits)
            end

          {{ver, typ, pkt}, bits}

        {:end, bits} ->
          {:end, bits}
      end
    end
  end

  def version_and_type(bits) do
    if String.length(bits) > 6 do
      {ver, bits} = String.split_at(bits, 3)
      {typ, bits} = String.split_at(bits, 3)
      ver = String.to_integer(ver, 2)
      typ = String.to_integer(typ, 2)
      {:ok, {ver, typ, bits}}
    else
      {:end, bits}
    end
  end

  def take_literal(bits) do
    take_literal(bits, "")
  end

  def take_literal(bits, numbits) do
    {chunk, bits} = String.split_at(bits, 5)
    {cont, chunk} = String.split_at(chunk, 1)

    if cont == "1" do
      take_literal(bits, numbits <> chunk)
    else
      lit = String.to_integer(numbits <> chunk, 2)
      {{:lit, lit}, bits}
    end
  end

  def take_operator(bits) do
    {lid, bits} = String.split_at(bits, 1)

    if lid == "0" do
      {len, bits} = String.split_at(bits, 15)
      len = String.to_integer(len, 2)
      {sub, bits} = String.split_at(bits, len)
      subs = parse(sub)
      {{:op, subs}, bits}
    else
      {nsp, bits} = String.split_at(bits, 11)
      nsp = String.to_integer(nsp, 2)

      {subs, bits} =
        Enum.reduce(1..nsp, {[], bits}, fn _, {subs, bits} ->
          {sub, bits} = parse_one(bits)
          {[sub | subs], bits}
        end)

      {{:op, subs}, bits}
    end
  end

  def val(pkt) do
    case pkt do
      {_, 4, {:lit, val}} -> val
      {_, 0, {:op, subs}} ->
        Enum.map(subs, &val/1)
        |> Enum.sum()
      {_, 1, {:op, subs}} ->
        Enum.map(subs, &val/1)
        |> Enum.product()
      {_, 2, {:op, subs}} ->
        Enum.map(subs, &val/1)
        |> Enum.min()
      {_, 3, {:op, subs}} ->
        Enum.map(subs, &val/1)
        |> Enum.max()
      {_, 5, {:op, [a,b]}} ->
        if val(b) > val(a) do
          1
        else
          0
        end
      {_, 6, {:op, [a,b]}} ->
        if val(b) < val(a) do
          1
        else
          0
        end
      {_, 7, {:op, [a,b]}} ->
        if val(b) == val(a) do
          1
        else
          0
        end
    end
  end
end
