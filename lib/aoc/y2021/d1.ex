defmodule Aoc.Y2021.D1 do
  use Aoc.Boilerplate,
    transform: fn raw -> raw |> String.split() |> Enum.map(&String.to_integer(&1)) end

  def part1(input \\ processed()) do
    input
    |> Enum.reduce([], &new_status/2)
    |> Enum.count(fn
      {_, :increased} -> true
      _ -> false
    end)
  end

  def part2(input \\ processed()) do
    {rest, statuses} =
      input
      |> Enum.reduce({[], []}, fn depth, acc ->
        case acc do
          {[i, j, k], statuses} ->
            {[depth, i, j], new_status(i + j + k, statuses)}
          {window, statuses} ->
            {[depth | window], statuses}
         end 
      end)

    statuses = new_status(Enum.sum(rest), statuses)

    statuses
    |> Enum.count(fn
      {_, :increased} -> true
      _ -> false
    end)
  end

  defp new_status(sum, []) do
    [{sum, nil}]
  end

  defp new_status(sum, [{prev_sum, _} | _] = statuses) when sum > prev_sum do
    [{sum, :increased} | statuses]
  end

  defp new_status(sum, [{prev_sum, _} | _] = statuses) when sum < prev_sum do
    [{sum, :decreased} | statuses]
  end

  defp new_status(sum, [{prev_sum, _} | _] = statuses) when sum == prev_sum do
    [{sum, :no_change} | statuses]
  end
end
