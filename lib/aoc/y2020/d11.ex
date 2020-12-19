defmodule Aoc.Y2020.D11 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, x}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {v, y}, row_acc ->
          case v do
            "L" -> Map.put(row_acc, {x, y}, :empty)
            "#" -> Map.put(row_acc, {x, y}, :occupied)
            "." -> Map.put(row_acc, {x, y}, :floor)
          end
        end)
      end)
    end

  def part1(ferry \\ processed()) do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(ferry, fn _i, prev_ferry ->
      new_ferry = next_round(prev_ferry)

      case Map.equal?(prev_ferry, new_ferry) do
        true -> {:halt, new_ferry}
        false -> {:cont, new_ferry}
      end
    end)
    |> Enum.reduce(0, fn {_, seat}, acc ->
      if seat == :occupied, do: acc + 1, else: acc
    end)
  end

  def part2(input \\ processed()) do
    nil
  end

  def next_round(ferry) do
    ferry
    |> Enum.reduce(%{}, fn {{x, y}, seat_state}, new_ferry ->
      case seat_state do
        :occupied ->
          seat_state = ferry |> count_occupied_neighboors({x, y}) |> new_seat_state(:occupied)
          Map.put(new_ferry, {x, y}, seat_state)

        :empty ->
          seat_state = ferry |> count_occupied_neighboors({x, y}) |> new_seat_state(:empty)
          Map.put(new_ferry, {x, y}, seat_state)

        _ ->
          new_ferry
      end
    end)
  end

  defp new_seat_state(0, :empty), do: :occupied
  defp new_seat_state(_, :empty), do: :empty
  defp new_seat_state(i, :occupied) when i >= 4, do: :empty
  defp new_seat_state(_, :occupied), do: :occupied

  def get_neighboors(ferry, {x, y}) do
    coordinates =
      for x1 <- (x - 1)..(x + 1),
          y1 <- (y - 1)..(y + 1),
          {x1, y1} != {x, y} && x1 >= 0 && y1 >= 0,
          do: {x1, y1}

    coordinates
    |> Enum.map(&Map.get(ferry, &1))
  end

  def count_occupied_neighboors(ferry, {x, y}) do
    ferry
    |> get_neighboors({x, y})
    |> Enum.reduce(0, fn seat, acc ->
      if seat == :occupied, do: acc + 1, else: acc
    end)
  end
end
