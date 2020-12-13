defmodule Aoc.Y2020.D9 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
    end

  @preamble 25

  defguard sums_to_needed_sum(first, second, needed_sum) when first + second == needed_sum

  def part1(input \\ processed()) do
    input
    |> Enum.chunk_every(@preamble + 1, 1, :discard)
    |> Enum.find_value(fn chunk ->
      {last, chunk} = List.pop_at(chunk, -1)
      if valid?(chunk, last), do: false, else: last
    end)
  end

  def part2(input \\ processed()) do
    invalid_number = input |> part1()

    Stream.iterate(2, &(&1 + 1))
    |> Enum.find_value(fn chunk_size ->
      input
      |> Enum.chunk_every(chunk_size, 1, :discard)
      |> Enum.find_value(fn chunk ->
        sum = Enum.sum(chunk)

        if sum == invalid_number do
          {min, max} = Enum.min_max(chunk)
          min + max
        end
      end)
    end)
  end

  def valid?(list, next) do
    get_two(list, next) != nil
  end

  def get_two([_first | rest] = list, needed_sum) do
    get_two(list, rest, needed_sum)
  end

  def get_two([], _needed_sum), do: nil

  def get_two(list, remainder, needed_sum) when length(list) == 1,
    do: get_two(remainder, needed_sum)

  def get_two([first | [second | _rest]], _remainder, needed_sum)
      when sums_to_needed_sum(first, second, needed_sum) do
    {first, second}
  end

  def get_two([first | [_second | rest]], remainder, needed_sum) do
    get_two([first | rest], remainder, needed_sum)
  end
end
