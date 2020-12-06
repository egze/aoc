defmodule Aoc.Y2020.D6 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n\n")
      |> Enum.map(fn group ->
        group
        |> String.split("\n")
        |> Enum.map(fn person ->
          person |> String.graphemes()
        end)
      end)
    end

  def part1(input \\ processed()) do
    input
    |> Enum.map(&count_yes_in_group/1)
    |> Enum.sum()
  end

  def part2(input \\ processed()) do
    input
    |> Enum.map(&count_all_yes_in_group/1)
    |> Enum.sum()
  end

  defp count_yes_in_group(group) do
    group
    |> Enum.reduce(MapSet.new(), fn answers, acc ->
      MapSet.union(acc, MapSet.new(answers))
    end)
    |> MapSet.size()
  end

  defp count_all_yes_in_group([first | rest]) do
    rest
    |> Enum.reduce(MapSet.new(first), fn answers, acc ->
      MapSet.intersection(acc, MapSet.new(answers))
    end)
    |> MapSet.size()
  end
end
