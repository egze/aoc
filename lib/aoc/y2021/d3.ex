defmodule Aoc.Y2021.D3 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
    end

  use Bitwise

  def part1(input \\ processed()) do
    gamma_bits =
      input
      |> transpose()
      |> Enum.map(fn row ->
        row
        |> Enum.frequencies_by(& &1)
        |> Enum.max_by(&elem(&1, 1))
        |> elem(0)
      end)

    gamma_rate = Integer.undigits(gamma_bits, 2)
    epsilon_rate = bnot(gamma_rate) &&& Integer.pow(2, length(gamma_bits)) - 1

    gamma_rate * epsilon_rate
  end

  def part2(input \\ processed()) do
    calculate(input, 0, &>/2) * calculate(input, 0, &<=/2)
  end

  defp calculate([remaining], _row_number, _sorter), do: Integer.undigits(remaining, 2)

  defp calculate(matrix, row_number, sorter) do
    bit =
      matrix
      |> transpose()
      |> Enum.at(row_number)
      |> Enum.frequencies()
      |> Enum.max_by(&elem(&1, 1), sorter)
      |> elem(0)

    new_matrix =
      matrix
      |> Enum.filter(fn row ->
        Enum.at(row, row_number) == bit
      end)

    calculate(new_matrix, row_number + 1, sorter)
  end

  def transpose(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
