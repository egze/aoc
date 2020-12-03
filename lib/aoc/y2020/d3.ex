defmodule Aoc.Y2020.D3 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.map(fn {index, line} ->
        {index, line}
      end)
    end

  def part1(input \\ processed()) do
    input
  end

  def part2(input \\ processed()) do
  end
end
