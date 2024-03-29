defmodule Aoc do
  @solutions %{
    2020 => [1, 2, 3, 4, 5, 6, 7, 8, 9],
    2021 => [1, 2, 3, 5, 9]
  }

  @solutions
  |> Enum.each(fn {year, days} ->
    m = Module.concat(__MODULE__, "Y#{year}")

    defmodule m do
      def main(spoil) do
        unquote(Macro.escape(days))
        |> Enum.each(fn day ->
          m = Module.concat(__MODULE__, "D#{day}")
          m.main(spoil)
        end)
      end
    end
  end)

  def main(spoil \\ false) do
    @solutions
    |> Enum.each(fn {year, _} ->
      m = Module.concat(__MODULE__, "Y#{year}")
      m.main(spoil)
    end)
  end
end
