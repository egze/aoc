defmodule Aoc.Y2020.D10 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
    end

  def part1(input \\ processed()) do
    jolts_diffs = jolts_diffs(input)

    %{1 => one, 3 => three} =
      jolts_diffs
      |> Enum.map(fn {_jolt, diff} -> diff end)
      |> Enum.frequencies()

    one * (three + 1)
  end

  def part2(input \\ processed()) do
    jolts_diffs = [{jolt, _diff} | _] = jolts_diffs(input)
    jolts = jolts_diffs |> Enum.map(fn {jolt, _diff} -> jolt end)
    device_joltage = jolt + 3
  end

  defp jolts_diffs(jolts) do
    jolts
    |> Enum.sort()
    |> Enum.reduce([], fn jolt, acc ->
      case acc do
        [] -> [{jolt, jolt}]
        [{prev_jolt, _diff} | _rest] -> [{jolt, jolt - prev_jolt} | acc]
      end
    end)
  end
end
