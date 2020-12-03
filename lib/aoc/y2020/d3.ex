defmodule Aoc.Y2020.D3 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      grid =
        raw
        |> String.split("\n", trim: true)
        |> Enum.with_index()
        |> Enum.flat_map(fn {line, index} ->
          line
          |> String.split("", trim: true)
          |> Enum.with_index()
          |> Enum.map(fn {char, char_index} ->
            {{index, char_index}, char}
          end)
        end)
        |> Enum.into(%{})

      width =
        raw
        |> String.split("\n")
        |> Enum.at(0)
        |> String.split("", trim: true)
        |> Enum.count()

      height =
        raw
        |> String.split("\n", trim: true)
        |> Enum.count()

      %{width: width, height: height, grid: grid}
    end

  @part_1_operations [{3, 1}]
  @part_2_operations [[{1, 1}], [{3, 1}], [{5, 1}], [{7, 1}], [{1, 2}]]

  @doc """
  Receives input in form of `%{width: 31, height: 323, grid: %{{0,0} => ".", {0,1} => "#"}, ...}`
  """
  def part1(input \\ processed()) do
    @part_1_operations
    |> Stream.cycle()
    |> Enum.take(input.height)
    |> count_trees(input)
  end

  def part2(input \\ processed()) do
    @part_2_operations
    |> Enum.map(fn ops ->
      ops
      |> Stream.cycle()
      |> Enum.take(input.height)
      |> count_trees(input)
    end)
    |> Enum.reduce(&(&1 * &2))
  end

  defp count_trees(moves, input) do
    moves
    |> Enum.reduce({0, {0, 0}}, fn {move_right, move_down}, {trees, {current_x, current_y}} ->
      x = current_x + move_down
      y = Integer.mod(current_y + move_right, input.width)

      case Map.get(input.grid, {x, y}, ".") do
        "." -> {trees, {x, y}}
        "#" -> {trees + 1, {x, y}}
      end
    end)
    |> elem(0)
  end
end
