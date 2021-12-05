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
    |> Enum.reverse()
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
    |> Enum.count(&(elem(&1, 1) >= 2))
  end

  def part2(input \\ processed()) do
    input
    |> Enum.reduce([], fn line, acc ->
      {:ok, [x1, y1, x2, y2], _, _, _, _} = VentParser.parse(line)
      [{{x1, y1}, {x2, y2}} | acc]
    end)
    |> Enum.reverse()
    |> Enum.reduce(%{}, fn
      {{x, y1}, {x, y2}}, acc ->
        for y <- y1..y2, reduce: acc do
          acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
        end

      {{x1, y}, {x2, y}}, acc ->
        for x <- x1..x2, reduce: acc do
          acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
        end

      {{x1, y1}, {x2, y2}}, acc when abs(x1 - x2) == abs(y1 - y2) ->
        for x <- x1..x2, y <- y1..y2, abs(x - x1) == abs(y - y1), reduce: acc do
          acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
        end

      _coords, acc ->
        acc
    end)
    |> Enum.count(&(elem(&1, 1) >= 2))
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
