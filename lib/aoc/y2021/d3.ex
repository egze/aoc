defmodule Aoc.Y2021.D3 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
    end

  def part1(input \\ processed()) do
    input
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn row ->
      row
      |> Enum.frequencies_by(& &1)
      |> Enum.max_by(&elem(&1, 1))
      |> elem(0)
    end)
    |> Integer.undigits(2)
  end

  def part2(input \\ processed()) do
  end
end
