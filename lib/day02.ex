defmodule Day02 do
  def part1(args) do
    args
    |> Enum.map(&is_line_safe?/1)
    |> Enum.frequencies()
    |> Map.get(true)
  end

  def part2(args) do
    args
    |> Enum.map(&is_line_safe_with_dampener?/1)
    |> Enum.frequencies()
    |> Map.get(true)
  end

  defp is_line_safe?(line) do
    line
    |> classify_diffs()
    |> check_safety()
  end

  defp check_safety(%{zero: _}), do: false
  defp check_safety(%{positive_out_of_range: _}), do: false
  defp check_safety(%{negative_out_of_range: _}), do: false
  defp check_safety(%{positive: _, negative: _}), do: false
  defp check_safety(_), do: true

  defp is_line_safe_with_dampener?(line) do
    line
    |> get_lists_with_missing_element()
    |> Map.values()
    |> Enum.any?(&is_line_safe?/1)
  end

  defp classify_diffs(line) do
    line
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.with_index()
    |> Stream.map(fn {[a, b], i} -> {b - a, i} end)
    |> Enum.group_by(fn
      {0, _} -> :zero
      {d, _} when d in [-1, -2, -3] -> :negative
      {d, _} when d < 0 -> :negative_out_of_range
      {d, _} when d in [1, 2, 3] -> :positive
      _ -> :positive_out_of_range
    end)
  end

  defp get_lists_with_missing_element(line) do
    0..(length(line) - 1)
    |> Enum.into(%{}, &{&1, List.delete_at(line, &1)})
  end
end
