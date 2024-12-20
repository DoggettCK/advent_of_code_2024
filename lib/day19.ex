defmodule Day19 do
  @cache :day19_cache

  def part1(patterns, designs) do
    designs
    |> Enum.map(&make_design(&1, patterns))
    |> Enum.filter(&(&1 > 0))
    |> length()
  end

  def part2(patterns, designs) do
    designs
    |> Enum.map(&make_design(&1, patterns))
    |> Enum.filter(&(&1 > 0))
    |> Enum.sum()
  end

  defp make_design("", _patterns), do: 1

  defp make_design(design, patterns) do
    case Cachex.exists?(@cache, design) do
      {:ok, true} ->
        @cache
        |> Cachex.get(design)
        |> elem(1)

      _ ->
        patterns
        |> Enum.filter(&String.starts_with?(design, &1))
        |> Enum.map(fn pattern ->
          ^pattern <> remaining_design = design

          result =
            make_design(remaining_design, patterns)

          {:ok, true} = Cachex.put(@cache, remaining_design, result)

          result
        end)
        |> Enum.sum()
    end
  end
end
