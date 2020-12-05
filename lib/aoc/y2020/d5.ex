defmodule Aoc.Y2020.D5 do
  use Aoc.Boilerplate,
    transform: fn raw -> raw |> String.split() end

  def part1(input \\ processed()) do
    input
    |> Enum.reduce(0, &max_seat_id_reducer/2)
  end

  def part2(input \\ processed()) do
    input
    |> Enum.map(&get_seat_id/1)
    |> Enum.sort()
    |> Enum.reduce_while(0, fn x, acc ->
      cond do
        acc == 0 -> {:cont, x}
        x - 1 == acc -> {:cont, x}
        :else -> {:halt, x - 1}
      end
    end)
  end

  defp max_seat_id_reducer(seat, acc) do
    seat_id = get_seat_id(seat)

    if seat_id >= acc, do: seat_id, else: acc
  end

  def get_seat_id(seat) do
    seat
    |> String.graphemes()
    |> Enum.map(fn char -> if char in ["F", "R"], do: 1, else: 0 end)
    |> Integer.undigits(2)
  end
end
