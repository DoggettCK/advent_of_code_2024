defmodule Day09 do
  import Common

  def part1(args) do
    args
    |> hd()
    |> to_filesystem()
    |> compact_filesystem()
    |> checksum()

    # |> print_filesystem()
  end

  def part2(_args) do
  end

  defp to_filesystem(int_string) do
    int_string
    |> string_to_ints()
    |> Enum.chunk_every(2, 2, [0])
    |> Enum.with_index()
    |> Enum.map(fn {[file_blocks, free_space], file_id} ->
      [
        List.duplicate(%{file_id: file_id}, file_blocks),
        List.duplicate(%{file_id: nil}, free_space)
      ]
    end)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.into(%{}, fn {block, idx} -> {idx, block} end)
  end

  defp compact_filesystem(filesystem) do
    filesystem
    |> list_bounds()
    |> Tuple.append(filesystem)
    |> simulate(fn _, {front, rear, fs} ->
      if front >= rear do
        {:halt, fs}
      else
        case {Map.get(fs, front), Map.get(fs, rear)} do
          {%{file_id: nil}, %{file_id: nil}} ->
            {:cont, {front, rear - 1, fs}}

          {%{file_id: nil} = null_block, block} ->
            {:cont,
             {front + 1, rear - 1,
              fs
              |> Map.put(front, block)
              |> Map.put(rear, null_block)}}

          {_block, %{file_id: nil}} ->
            {:cont, {front + 1, rear - 1, fs}}

          _ ->
            {:cont, {front + 1, rear, fs}}
        end
      end
    end)
  end

  defp print_filesystem(filesystem) do
    0..(map_size(filesystem) - 1)
    |> Enum.map(fn idx ->
      case Map.get(filesystem, idx) do
        %{file_id: nil} -> "."
        %{file_id: file_id} -> to_string(file_id)
      end
    end)
    |> Enum.join("")
  end

  defp string_to_ints(int_string) do
    int_string
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp list_bounds(filesystem), do: {0, map_size(filesystem) - 1}
  defp list_range(filesystem), do: 0..(map_size(filesystem) - 1)

  defp checksum(filesystem) do
    filesystem
    |> list_range()
    |> Enum.reduce(0, fn idx, acc ->
      case Map.get(filesystem, idx) do
        %{file_id: nil} ->
          acc

        %{file_id: file_id} ->
          acc + idx * file_id
      end
    end)
  end
end
