defmodule Test.Common do
  import Common, only: [build_grid_from_lines: 1]

  def read_file(filename) do
    filename
    |> File.read!()
    |> String.trim()
  end

  def read_lines(filename, opts \\ []) do
    trim = Keyword.get(opts, :trim, true)

    filename
    |> read_file()
    |> String.split("\n", trim: trim)
  end

  def read_ints(filename) do
    filename
    |> read_lines()
    |> Enum.map(fn line ->
      ~r/-?\d+/
      |> Regex.scan(line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def read_int_line(filename) do
    filename
    |> read_ints()
    |> hd
  end

  @doc """
  Given a filename, read the file into a map with coordinates (i.e. {3, 21}) as
  the key, and the character at those coordinates as the value.
  """
  def read_grid(filename, opts \\ []) do
    type = Keyword.get(opts, :type)

    grid =
      filename
      |> read_lines()
      |> build_grid_from_lines()

    grid =
      case type do
        :int ->
          Map.new(grid, fn {k, v} -> {k, String.to_integer(v)} end)

        _ ->
          grid
      end

    {{max_x, max_y}, _} = Enum.max_by(grid, fn {coord, _} -> coord end)

    %{grid: grid, max_x: max_x, max_y: max_y}
  end

  def read_int_grid(filename), do: read_grid(filename, type: :int)

  def read_grid_from_string(str, opts \\ []) do
    trim = Keyword.get(opts, :trim, true)

    grid =
      str
      |> String.split("\n", trim: trim)
      |> build_grid_from_lines()

    {{max_x, max_y}, _} = Enum.max_by(grid, fn {coord, _} -> coord end)

    %{grid: grid, max_x: max_x, max_y: max_y}
  end
end
