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
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({0, 0, input}, fn _i, {index, sum, instructions} ->
      case Map.get(instructions, index) do
        {"nop", _} -> {:cont, {index + 1, sum, Map.delete(instructions, index)}}
        {"jmp", jmp} -> {:cont, {index + jmp, sum, Map.delete(instructions, index)}}
        {"acc", i} -> {:cont, {index + 1, sum + i, Map.delete(instructions, index)}}
        nil -> {:halt, sum}
      end
    end)
  end

  def part2(input \\ processed()) do
    key = (input |> Map.keys() |> Enum.sort() |> List.last()) + 1
    instructions = Map.put(input, key, :end)

    instructions
    |> run(0, 0, [], nil)
    |> List.flatten()
    |> Enum.find(&(&1 != :infinite_loop))
  end

  defp run(instructions, sum, index, visited, corrected_index) do
    case {Map.get(instructions, index), corrected_index, index in visited} do
      {:end, _, false} ->
        sum

      {_, _, true} ->
        :infinite_loop

      {{"nop", i}, nil, false} ->
        [
          run(instructions, sum, index + i, [index | visited], index),
          run(instructions, sum, index + 1, [index | visited], nil)
        ]

      {{"nop", _}, ^corrected_index, false} ->
        run(instructions, sum, index + 1, [index | visited], corrected_index)

      {{"jmp", jmp}, nil, false} ->
        [
          run(instructions, sum, index + 1, [index | visited], index),
          run(instructions, sum, index + jmp, [index | visited], nil)
        ]

      {{"jmp", jmp}, ^corrected_index, false} ->
        run(instructions, sum, index + jmp, [index | visited], corrected_index)

      {{"acc", i}, ^corrected_index, false} ->
        run(instructions, sum + i, index + 1, [index | visited], corrected_index)
    end
  end
end
