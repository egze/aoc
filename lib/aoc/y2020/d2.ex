defmodule Aoc.Y2020.D2 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n")
      |> Enum.map(fn line ->
        [rules, password] = line |> String.split(": ")
        [occurance, letter] = rules |> String.split(" ")
        [min, max] = occurance |> String.split("-")

        {password, String.to_integer(min), String.to_integer(max), letter}
      end)
    end

  def part1(input \\ processed()) do
    input
    |> Enum.reduce(0, fn {password, min, max, letter}, valid_passwords ->
      if valid_password?(password, min, max, letter) do
        valid_passwords + 1
      else
        valid_passwords
      end
    end)
  end

  def part2(input \\ processed()) do
    input
    |> Enum.reduce(0, fn {password, position1, position2, letter}, valid_passwords ->
      if valid_toboggan_password?(password, position1, position2, letter) do
        valid_passwords + 1
      else
        valid_passwords
      end
    end)
  end

  @doc """
    Validates the password based on rules.

    Uses a regex, for example `~r/^([^a]*a){1,3}[^a]*$/`
    ^     Start of string
    (     Start of group
    [^a]* Any character except `a`, zero or more times
    a     our character `a`
    ){1,3} End and repeat the group 1 to 3 times
    [^a]* Any character except `a`, zero or more times again
    $     End of string

    Examples:

      iex> Aoc.Y2020.D2.valid_password?("aabbcc", 1, 2, "a")
      true

      iex> Aoc.Y2020.D2.valid_password?("aaabbcc", 1, 2, "a")
      false

  """
  def valid_password?(password, min, max, letter) do
    Regex.match?(~r/^([^#{letter}]*#{letter}){#{min},#{max}}[^#{letter}]*$/, password)
  end

  @doc """
    Validates the password based on Toboggan rule.

    Examples:

      iex> Aoc.Y2020.D2.valid_toboggan_password?("aabbcc", 1, 3, "a")
      true

      iex> Aoc.Y2020.D2.valid_toboggan_password?("aaabbcc", 1, 2, "a")
      false

  """
  def valid_toboggan_password?(password, position1, position2, letter) do
    letter1 = String.at(password, position1 - 1)
    letter2 = String.at(password, position2 - 1)

    (letter1 == letter || letter2 == letter) && letter1 != letter2
  end
end
