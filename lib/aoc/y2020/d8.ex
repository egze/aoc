defmodule Aoc.Y2020.D8 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(fn line ->
        [instruction, value] = line |> String.split(" ")
        {instruction, String.to_integer(value)}
      end)
      |> Enum.with_index()
      |> Enum.map(fn {v, i} -> {i, v} end)
      |> Enum.into(%{})
    end

  def part1(input \\ processed()) do
    Stream.iterate(0, & &1 + 1)
    |> Enum.reduce_while({0, 0, input}, fn _i, {index, sum, instructions} ->
      case Map.get(instructions, index) do
        nil -> {:halt, sum}
        {"nop", _} -> {:cont, {index + 1, sum, Map.delete(instructions, index)}}
        {"jmp", jmp} -> {:cont, {index + jmp, sum, Map.delete(instructions, index)}}
        {"acc", i} -> {:cont, {index + 1, sum + i, Map.delete(instructions, index)}}
      end
    end)
  end

  def part2(input \\ processed()) do
    input
  end
end
