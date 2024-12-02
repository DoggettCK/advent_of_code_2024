defmodule Day01 do
  def part1(args) do
    {:ok, first, second} =
      args
      |> transpose_to_lists()

    sorted_first = Enum.sort(first)
    sorted_second = Enum.sort(second)

    sorted_first
    |> Enum.zip(sorted_second)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2(args) do
    {:ok, first, second} =
      args
      |> transpose_to_lists()

    second_freqs = Enum.frequencies(second)

    first
    |> Enum.sort()
    |> Enum.map(&(&1 * Map.get(second_freqs, &1, 0)))
    |> Enum.sum()
  end

  defp transpose_to_lists(list, first \\ [], second \\ [])
  defp transpose_to_lists([], first, second), do: {:ok, first, second}

  defp transpose_to_lists([[a, b] | rest], first, second),
    do: transpose_to_lists(rest, [a | first], [b | second])
end
