defmodule Aoc.Y2021.D2 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(fn line ->
        [direction, steps] = String.split(line)
        {String.to_atom(direction), String.to_integer(steps)}
      end)
    end

  def part1(input \\ processed()) do
    {horizontal, depth} =
      input
      |> Enum.reduce({0, 0}, fn command, {horizontal, depth} ->
        case command do
          {:forward, steps} ->
            {horizontal + steps, depth}

          {:down, steps} ->
            {horizontal, depth + steps}

          {:up, steps} ->
            {horizontal, depth - steps}
        end
      end)

    horizontal * depth
  end

  def part2(input \\ processed()) do
    {horizontal, depth, _aim} =
      input
      |> Enum.reduce({0, 0, 0}, fn command, {horizontal, depth, aim} ->
        case command do
          {:forward, steps} ->
            {horizontal + steps, depth + aim * steps, aim}

          {:down, steps} ->
            {horizontal, depth, aim + steps}

          {:up, steps} ->
            {horizontal, depth, aim - steps}
        end
      end)

    horizontal * depth
  end
end
