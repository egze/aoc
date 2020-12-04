defmodule Aoc.Y2020.D4 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split()
        |> Enum.map(& String.split(&1, ":"))
      end)
    end

  def part1(input \\ processed()) do
    input
  end

  def part2(input \\ processed()) do
  end
end
