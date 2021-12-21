defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task

  def run(_) do
    Mix.Task.run("app.start")
    {:ok, text} = File.read("input")
    groups = Aoc.parse(text)
    IO.puts(Aoc.part1(groups))
    IO.puts(Aoc.part2(groups))
  end
end
