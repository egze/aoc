defmodule Aoc.Y2020.D10 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
    end

  def part1(input \\ processed()) do
    {jolts, diffs} =
      input
      |> Enum.sort()
      |> Enum.reduce({[], []}, fn jolt, acc ->
        case acc do
          {[], []} -> {[jolt], [jolt]}
          {[prev_jolt | _rest] = jolts, diffs} -> {[jolt | jolts], [jolt - prev_jolt | diffs]}
        end
      end)

    %{1 => one, 3 => three} =
      [3 | diffs]
      |> Enum.frequencies()

    one * three
  end

  def part2(input \\ processed()) do
    input
  end
end
