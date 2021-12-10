defmodule Aoc.Y2021.D9 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
      end)
    end

  alias __MODULE__.{Cave, Recursor}

  def part1(input \\ processed()) do
    cave =
      input
      |> Enum.reduce(Cave.new(), &Cave.add_lava_tube(&2, &1))

    cave.lava_tubes
    |> Enum.filter(fn {coords, _h} -> Cave.low_point?(cave, coords) end)
    |> Enum.map(fn {_, h} -> h + 1 end)
    |> Enum.sum()
  end

  def part2(input \\ processed()) do
    cave =
      input
      |> Enum.reduce(Cave.new(), &Cave.add_lava_tube(&2, &1))

    cave.lava_tubes
    |> Enum.filter(fn {coords, _h} -> Cave.low_point?(cave, coords) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(&Recursor.recur(cave.lava_tubes, &1))
    |> Enum.map(&Enum.uniq/1)
  end

  defmodule Cave do
    defstruct [:lava_tubes, :rows]

    def new do
      %Cave{lava_tubes: %{}, rows: 0}
    end

    def add_lava_tube(%Cave{} = cave, lava_tube) do
      lava_tube
      |> Enum.with_index()
      |> Enum.reduce(cave, fn {height, c}, cave_acc ->
        %{cave_acc | lava_tubes: Map.put(cave_acc.lava_tubes, {cave_acc.rows, c}, height)}
      end)
      |> then(fn cave ->
        cave
        |> Map.update!(:rows, &(&1 + 1))
      end)
    end

    def low_point?(cave, {r, c} = coords) do
      height = cave.lava_tubes[coords]

      cave.lava_tubes[{r - 1, c}] > height and
        cave.lava_tubes[{r + 1, c}] > height and
        cave.lava_tubes[{r, c - 1}] > height and
        cave.lava_tubes[{r, c + 1}] > height
    end
  end

  defmodule Recursor do
    def recur(lava_tubes, coords) do
      recur(lava_tubes, coords, [])
    end

    defp recur(lava_tubes, {r, c} = coords, acc) do
      lava_tubes = Map.delete(lava_tubes, coords)
      IO.inspect(lava_tubes)

      recur(lava_tubes, coords, {r - 1, c}, [coords | acc]) ++
        recur(lava_tubes, coords, {r + 1, c}, [coords | acc]) ++
        recur(lava_tubes, coords, {r, c - 1}, [coords | acc]) ++
        recur(lava_tubes, coords, {r, c + 1}, [coords | acc])
    end

    defp recur(lava_tubes, coords, next_coords, acc)
         when not is_map_key(lava_tubes, next_coords) do
      IO.inspect({Enum.uniq(acc), coords, next_coords}, label: "not is_map_key")
      acc
    end

    defp recur(lava_tubes, coords, next_coords, acc)
         when :erlang.map_get(next_coords, lava_tubes) == 9 do
      IO.inspect({Enum.uniq(acc), coords, next_coords}, label: "9")
      acc
    end

    defp recur(lava_tubes, coords, next_coords, acc)
         when :erlang.map_get(next_coords, lava_tubes) - :erlang.map_get(coords, lava_tubes) != 1 do
      IO.inspect({Enum.uniq(acc), coords, next_coords}, label: "!= 1")
      acc
    end

    defp recur(lava_tubes, coords, {r, c} = next_coords, acc) do
      recur(lava_tubes, next_coords, {r - 1, c}, [coords | acc]) ++
        recur(lava_tubes, next_coords, {r + 1, c}, [coords | acc]) ++
        recur(lava_tubes, next_coords, {r, c - 1}, [coords | acc]) ++
        recur(lava_tubes, next_coords, {r, c + 1}, [coords | acc])
    end
  end
end
