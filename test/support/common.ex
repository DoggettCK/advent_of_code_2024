defmodule Test.Common do
  def load_input(filename, opts \\ []) do
    trim = Keyword.get(opts, :trim, true)

    filename
    |> File.read!()
    |> String.split("\n", trim: trim)
  end

  def read_ints(filename) do
    filename
    |> load_input()
    |> Enum.map(fn line ->
      ~r/\d+/
      |> Regex.scan(line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Given a filename, read the file into a map with coordinates (i.e. {3, 21}) as
  the key, and the character at those coordinates as the value.
  """
  def read_grid(filename) do
    grid =
      filename
      |> load_input()
      |> Enum.with_index()
      |> Enum.reduce(%{max_x: -1, max_y: -1}, fn {row, row_idx}, acc ->
        row
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.into(acc, fn {char, col_idx} ->
          {{col_idx, row_idx}, char}
        end)
      end)

    {{max_x, max_y}, _} = Enum.max_by(grid, fn {coord, _} -> coord end)

    %{grid: grid, max_x: max_x, max_y: max_y}
  end
end
