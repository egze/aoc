defmodule Aoc.Y2021.D5 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n", trim: true)
    end

  alias __MODULE__.VentParser

  def part1(input \\ processed()) do
    input
    |> Enum.reduce([], fn line, acc ->
      {:ok, [x1, y1, x2, y2], _, _, _, _} = VentParser.parse(line)
      [{{x1, y1}, {x2, y2}} | acc]
    end)
    |> Enum.reduce(%{}, fn
      {{x, y1}, {x, y2}}, acc ->
        for y <- y1..y2, reduce: acc do
          acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
        end

      {{x1, y}, {x2, y}}, acc ->
        for x <- x1..x2, reduce: acc do
          acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
        end

      _, acc ->
        acc
    end)
    |> Enum.count(fn {_k, v} -> v > 1 end)
  end

  def part2(input \\ processed()) do
    input
    |> Enum.reduce([], fn line, acc ->
      {:ok, [x1, y1, x2, y2], _, _, _, _} = VentParser.parse(line)
      [{{x1, y1}, {x2, y2}} | acc]
    end)
    |> Enum.reduce(%{}, fn
      {{x, y1}, {x, y2}}, acc ->
        for y <- y1..y2, reduce: acc do
          acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
        end

      {{x1, y}, {x2, y}}, acc ->
        for x <- x1..x2, reduce: acc do
          acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
        end

      {{x1, y1}, {x2, y2}}, acc ->
        for {x, y} <- Enum.zip(x1..x2, y1..y2), reduce: acc do
          acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
        end
    end)
    |> Enum.count(fn {_k, v} -> v > 1 end)
  end

  defmodule VentParser do
    import NimbleParsec

    coordinates =
      integer(min: 1)
      |> ignore(string(","))
      |> integer(min: 1)

    defparsec(:parse, coordinates |> ignore(string(" -> ")) |> concat(coordinates))
  end
end
