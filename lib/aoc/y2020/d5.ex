defmodule Aoc.Y2020.D5 do
  use Aoc.Boilerplate,
    transform: fn raw -> raw |> String.split() end

  def part1(input \\ processed()) do
    input
    |> Enum.map(&get_seat_id/1)
    |> Enum.max()
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

  @doc """
  Seat ID.

      iex> Aoc.Y2020.D5.get_seat_id("FBFBBFFRLR")
      357

      iex> Aoc.Y2020.D5.get_seat_id("BFFFBBFRRR")
      567

      iex> Aoc.Y2020.D5.get_seat_id("FFFBBBFRRR")
      119

      iex> Aoc.Y2020.D5.get_seat_id("BBFFBBFRLL")
      820
  """
  def get_seat_id(seat) do
    {row, col, _, _} =
      seat
      |> String.graphemes()
      |> Enum.reduce({0, 0, 0..127, 0..7}, fn char, {row, col, row_range, col_range} ->
        case char do
          "F" ->
            first..last = row_range
            new_row_last = floor((first + last) / 2)
            {first, col, first..new_row_last, col_range}

          "B" ->
            first..last = row_range
            new_row_first = round((first + last) / 2)
            {new_row_first, col, new_row_first..last, col_range}

          "R" ->
            first..last = col_range
            new_col_first = round((first + last) / 2)
            {row, new_col_first, row_range, new_col_first..last}

          "L" ->
            first..last = col_range
            new_col_last = floor((first + last) / 2)
            {row, first, row_range, first..new_col_last}
        end
      end)

    row * 8 + col
  end
end
