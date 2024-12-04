defmodule Day02 do
  def part1(args) do
    args
    |> Enum.map(&is_line_safe?/1)
    |> Enum.frequencies()
    |> Map.get(:safe)
  end

  def part2(args) do
    args
    |> Enum.map(&is_line_safe_with_dampener?/1)
    |> dbg
    # |> Enum.frequencies()
    # |> Map.get(:safe)
  end

  defp is_line_safe?(list, direction \\ :unknown)
  defp is_line_safe?([_], _), do: :safe
  defp is_line_safe?([a, b | rest], :unknown) when a < b, do: is_line_safe?([a, b | rest], :increasing)
  defp is_line_safe?([a, b | rest], :unknown), do: is_line_safe?([a, b | rest], :decreasing)
  defp is_line_safe?([a, b | rest], :decreasing) do
    if a > b && abs(b - a) in 1..3 do
      is_line_safe?([b | rest], :decreasing)
    else
      :unsafe
    end
  end
  defp is_line_safe?([a, b | rest], :increasing) do
    if a < b && abs(b - a) in 1..3 do
      is_line_safe?([b | rest], :increasing)
    else
      :unsafe
    end
  end

  defp is_line_safe_with_dampener?(list, direction \\ :unknown)
  defp is_line_safe_with_dampener?([_], _), do: :safe
  defp is_line_safe_with_dampener?([a, b | rest], :unknown) when a < b, do: is_line_safe_with_dampener?([a, b | rest], :increasing)
  defp is_line_safe_with_dampener?([a, b | rest], :unknown), do: is_line_safe_with_dampener?([a, b | rest], :decreasing)
  defp is_line_safe_with_dampener?([a, b | rest], direction) do

  end
end
