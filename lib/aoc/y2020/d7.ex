defmodule Aoc.Y2020.D7 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.reduce(Graph.new(), fn line, graph ->
        [main, others] = line |> String.split(" contain ")
        main_parsed = main |> String.replace(" bags", "")

        others
        |> String.split([", ", "."], trim: true)
        |> Enum.map(fn other_str ->
          other_str
          |> String.replace([" bags", "bag"], "", global: true)
          |> Integer.parse()
          |> case do
            :error -> {0, "no bags"}
            {n, bag} -> {n, String.trim(bag)}
          end
        end)
        |> Enum.reduce(graph, fn {count, bag}, graph_acc ->
          case count do
            0 -> graph_acc
            _ -> Graph.add_edge(graph_acc, main_parsed, bag, label: count)
          end
        end)
      end)
    end

  def part1(graph \\ processed()) do
    graph
    |> Graph.reaching_neighbors(["shiny gold"])
    |> Enum.count()
  end

  def part2(graph \\ processed()) do
    count_bags(graph, "shiny gold") - 1
  end

  defp count_bags(graph, vertex) do
    graph
    |> Graph.out_edges(vertex)
    |> Enum.reduce(1, fn %{v2: vertex, label: n}, total ->
      total + n * count_bags(graph, vertex)
    end)
  end
end
