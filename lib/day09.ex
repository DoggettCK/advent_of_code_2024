defmodule Day09 do
  import Common

  def part1(args) do
    args
    |> to_filesystem()
    |> compact_filesystem()
    |> checksum()
  end

  defmodule Block do
    defstruct file_id: nil, start: -1, length: -1

    def checksum(%__MODULE__{} = block) do
      block.start..(block.start + block.length - 1)
      |> Enum.map(&(&1 * block.file_id))
      |> Enum.sum()
    end
  end

  def part2(args) do
    args
    |> to_block_filesystem()
    |> compact_block_filesystem()
    |> block_checksum()
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

  defp to_block_filesystem(int_string) do
    {blocks, _} =
      int_string
      |> string_to_ints()
      |> Enum.chunk_every(2, 2, [0])
      |> Enum.with_index()
      |> Enum.flat_map_reduce(0, fn {[file_blocks, free_space], file_id}, acc ->
        {
          [
            %Block{file_id: file_id, start: acc, length: file_blocks},
            %Block{file_id: nil, start: acc + file_blocks, length: free_space}
          ],
          acc + file_blocks + free_space
        }
      end)

    files =
      blocks
      |> Enum.reject(&is_nil(&1.file_id))
      |> Enum.into(%{}, &{&1.file_id, &1})

    free_blocks = Enum.filter(blocks, &is_nil(&1.file_id))

    %{free_space: free_blocks, files: files}
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

  defp compact_block_filesystem(filesystem) do
    max_id = map_size(filesystem.files) - 1

    max_id..0
    |> Enum.reduce(filesystem, fn file_id, fs ->
      %{files: files, free_space: free_space} = fs

      file = Map.get(files, file_id)

      case find_free_space(free_space, file) do
        {:no_space_found, ^free_space, ^file} ->
          fs

        {:ok, updated_free_space, updated_file} ->
          %{fs | files: Map.put(files, file_id, updated_file), free_space: updated_free_space}
      end
    end)
  end

  defp find_free_space(fs_blocks, file, seen \\ [])

  defp find_free_space([], file, seen) do
    {:no_space_found, Enum.reverse(seen), file}
  end

  defp find_free_space(
         [%Block{start: fs_start, length: fs_length} | fs_blocks],
         %Block{start: f_start, length: fs_length} = file,
         seen
       )
       when f_start > fs_start do
    updated_file = %Block{file | start: fs_start}

    {:ok, Enum.reverse(seen) ++ fs_blocks, updated_file}
  end

  defp find_free_space(
         [%Block{start: fs_start, length: fs_length} | fs_blocks],
         %Block{start: f_start, length: f_length} = file,
         seen
       )
       when fs_length > f_length and f_start > fs_start do
    shrunk_free_space = %Block{
      file_id: nil,
      start: fs_start + f_length,
      length: fs_length - f_length
    }

    updated_file = %Block{file | start: fs_start}

    {:ok, Enum.reverse(seen) ++ [shrunk_free_space | fs_blocks], updated_file}
  end

  defp find_free_space([fs | fs_blocks], file, seen) do
    find_free_space(fs_blocks, file, [fs | seen])
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

  defp block_checksum(filesystem) do
    %{files: files} = filesystem

    files
    |> Map.values()
    |> Enum.map(&Block.checksum/1)
    |> Enum.sum()
  end
end
