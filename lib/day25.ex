defmodule Day25 do
  import Common

  def part1(args) do
    %{
      key: keys,
      lock: locks
    } =
      args
      |> Enum.chunk_every(7)
      |> Enum.map(&parse_key_or_lock/1)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    for key <- keys,
        lock <- locks,
        true == fits?(lock, key) do
      1
    end
    |> Enum.sum()
  end

  defp parse_key_or_lock(["#####" | _] = lines), do: parse_key_or_lock(lines, :lock)
  defp parse_key_or_lock(["....." | _] = lines), do: parse_key_or_lock(lines, :key)

  defp parse_key_or_lock(lock, type) do
    grid = build_grid_from_lines(lock)

    heights =
      0..4
      |> Enum.map(fn col ->
        grid
        |> Map.filter(fn
          {{^col, _}, "#"} -> true
          _ -> false
        end)
        |> map_size()
        |> Kernel.-(1)
      end)

    {type, heights}
  end

  defp fits?(lock, key) do
    lock
    |> Enum.zip(key)
    |> Enum.map(fn {a, b} -> a + b end)
    |> Enum.all?(&(&1 <= 5))
  end
end
