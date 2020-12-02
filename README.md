# Advent of Code

Project to simplify AoC challenges. Originally created by [@NobbZ](https://github.com/NobbZ) [aoc_ex](https://gitlab.com/NobbZ/aoc_ex)

## Usage

Copy/paste your daily input to `priv`. For example the challenge in year 2020 for day 1 goes to  `priv/y2020/d1.txt`.

Add to `lib/aoc.ex` the year and day to the `@solutions` module attribute.

Create the module for your day. For example year 2020 for day 1 means `lib/aoc/y2020/d1.ex`.

Use this template:

```elixir
defmodule Aoc.Y2020.D1 do
  use Aoc.Boilerplate,
    transform: fn raw -> raw |> String.split() |> Enum.map(&String.to_integer(&1)) end

  def part1(input \\ processed()) do
  end

  def part2(input \\ processed()) do
  end
end
```

In the example above look at the `transform` function, it parses each line to an integer. If you need to parse differently, change this function.

Then solve your challenges. `part1/1` and `part2/1` functions should return the answer.

Run `mix aoc` or `mix aoc --spoil`. Or also work in IEx.
