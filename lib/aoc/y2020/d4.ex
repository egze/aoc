defmodule Aoc.Y2020.D4 do
  use Aoc.Boilerplate,
    transform: fn raw ->
      raw
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split()
        |> Enum.map(fn field ->
          [key, value] = String.split(field, ":")
          {key, value}
        end)
        |> Enum.into(%{})
      end)
    end

  @required_fields ~w(byr iyr eyr hgt hcl ecl pid)

  def part1(input \\ processed()) do
    input
    |> Enum.filter(&simple_valid_passport?/1)
    |> Enum.count()
  end

  def part2(input \\ processed()) do
    input
    |> Enum.filter(&(Enum.sort(@required_fields) == Enum.sort(Map.keys(&1) -- ["cid"])))
    |> Enum.filter(&strict_valid_passport?/1)
    |> Enum.count()
  end

  defp simple_valid_passport?(passport) do
    @required_fields
    |> Enum.all?(&Map.has_key?(passport, &1))
  end

  @doc """
  validates passport

      iex> Aoc.Y2020.D4.strict_valid_passport?(%{"byr" => "1980", "ecl" => "grn", "eyr" => "2030", "hcl" => "#623a2f", "hgt" => "74in", "iyr" => "2012", "pid" => "087499704"})
      true

      iex> Aoc.Y2020.D4.strict_valid_passport?(%{"byr" => "1989", "cid" => "129", "ecl" => "blu", "eyr" => "2029", "hcl" => "#a97842", "hgt" => "165cm", "iyr" => "2014", "pid" => "896056539"})
      true

      iex> Aoc.Y2020.D4.strict_valid_passport?(%{"byr" => "2001", "cid" => "88", "ecl" => "hzl", "eyr" => "2022", "hcl" => "#888785", "hgt" => "164cm", "iyr" => "2015", "pid" => "545766238"})
      true

      iex> Aoc.Y2020.D4.strict_valid_passport?(%{"byr" => "1944", "ecl" => "blu", "eyr" => "2021", "hcl" => "#b6652a", "hgt" => "158cm", "iyr" => "2010", "pid" => "093154719"})
      true

      iex> Aoc.Y2020.D4.strict_valid_passport?(%{"byr" => "1926", "cid" => "100", "ecl" => "amb", "eyr" => "1972", "hcl" => "#18171d", "hgt" => "170", "iyr" => "2018", "pid" => "186cm"})
      false

      iex> Aoc.Y2020.D4.strict_valid_passport?(%{"byr" => "1946", "ecl" => "grn", "eyr" => "1967", "hcl" => "#602927", "hgt" => "170cm", "iyr" => "2019", "pid" => "012533040"})
      false

      iex> Aoc.Y2020.D4.strict_valid_passport?(%{"byr" => "1992", "cid" => "277", "ecl" => "brn", "eyr" => "2020", "hcl" => "dab227", "hgt" => "182cm", "iyr" => "2012", "pid" => "021572410"})
      false

      iex> Aoc.Y2020.D4.strict_valid_passport?(%{"byr" => "2007", "ecl" => "zzz", "eyr" => "2038", "hcl" => "74454a", "hgt" => "59cm", "iyr" => "2023", "pid" => "3556412378"})
      false
  """
  def strict_valid_passport?(passport) do
    passport
    |> Enum.all?(&valid_field?/1)
  end

  defp valid_field?({"byr", byr}) do
    case Integer.parse(byr) do
      {byr_int, ""} -> byr_int in 1920..2002
      _ -> false
    end
  end

  defp valid_field?({"iyr", iyr}) do
    case Integer.parse(iyr) do
      {iyr_int, ""} -> iyr_int in 2010..2020
      _ -> false
    end
  end

  defp valid_field?({"eyr", eyr}) do
    case Integer.parse(eyr) do
      {eyr_int, ""} -> eyr_int in 2020..2030
      _ -> false
    end
  end

  defp valid_field?({"hgt", hgt}) do
    case Integer.parse(hgt) do
      {hgt_int, "cm"} -> hgt_int in 150..193
      {hgt_int, "in"} -> hgt_int in 59..76
      _ -> false
    end
  end

  defp valid_field?({"hcl", hcl}) do
    String.match?(hcl, ~r/^#[0-9a-f]{6}$/)
  end

  defp valid_field?({"ecl", ecl}) do
    ecl in ~w(amb blu brn gry grn hzl oth)
  end

  defp valid_field?({"pid", pid}) do
    String.match?(pid, ~r/^\d{9}$/)
  end

  defp valid_field?({"cid", _cid}), do: true
end
