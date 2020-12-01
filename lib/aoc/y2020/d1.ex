defmodule Aoc.Y2020.D1 do
  use Aoc.Boilerplate,
    transform: fn raw -> raw |> String.split() |> Enum.map(&String.to_integer(&1)) end

  def part1(input \\ processed()) do
    [{x, y}] =
      Stream.flat_map(input, fn i ->
        Stream.flat_map(input, fn j ->
          [{i, j}]
        end)
      end)
      |> Stream.filter(fn {x, y} ->
        x + y == 2020
      end)
      |> Enum.take(1)

    x * y
  end

  def part2(input \\ processed()) do
    [{x, y, z}] =
      Stream.flat_map(input, fn i ->
        Stream.flat_map(input, fn j ->
          Stream.flat_map(input, fn k ->
            [{i, j, k}]
          end)
        end)
      end)
      |> Stream.filter(fn {x, y, k} ->
        x + y + k == 2020
      end)
      |> Enum.take(1)

    x * y * z
  end
end
