defmodule Day04 do
  import Common

  def part1(grid) do
    grid
    |> find_chars("X")
    |> build_neighbor_lists(grid[:max_x], 4)
    |> build_words(grid)
    |> Enum.filter(&("XMAS" == &1))
    |> length()
  end

  def part2(grid) do
    grid
    |> find_chars("A")
    |> build_crosses(grid[:max_x])
    |> build_words(grid)
    |> Enum.filter(fn
      "MSAMS" -> true
      "MMASS" -> true
      "SSAMM" -> true
      "SMASM" -> true
      _ -> false
    end)
    |> length()
  end

  defp find_chars(grid, char) do
    grid
    |> filter_from_grid(char)
    |> Map.keys()
    |> Enum.sort()
  end

  defp build_neighbor_lists(chars, n, count) do
    chars
    |> Stream.map(&{&1, get_directions(&1, count, n)})
    |> Enum.flat_map(fn {coord, directions} ->
      Enum.map(directions, &neighbors(coord, count, &1))
    end)
  end

  defp get_directions({x, y}, count, _n) when x < count - 1 and y < count - 1 do
    ~w(east southeast south)a
  end

  defp get_directions({x, y}, count, n) when x < count - 1 and y > n + 1 - count do
    ~w(north northeast east)a
  end

  defp get_directions({x, y}, count, n) when x > n + 1 - count and y < count - 1 do
    ~w(south southwest west)a
  end

  defp get_directions({x, y}, count, n) when x > n + 1 - count and y > n + 1 - count do
    ~w(north west northwest)a
  end

  defp get_directions({x, _y}, count, _n) when x < count - 1 do
    ~w(north northeast east southeast south)a
  end

  defp get_directions({x, _y}, count, n) when x > n + 1 - count do
    ~w(north south southwest west northwest)a
  end

  defp get_directions({_x, y}, count, _n) when y < count - 1 do
    ~w(east southeast south southwest west)a
  end

  defp get_directions({_x, y}, count, n) when y > n + 1 - count do
    ~w(north northeast east west northwest)a
  end

  defp get_directions(_coords, _count, _n) do
    ~w(north northeast east southeast south southwest west northwest)a
  end

  defp neighbors({x, y}, count, :north), do: Enum.map(0..(count - 1), &{x, y - &1})
  defp neighbors({x, y}, count, :northeast), do: Enum.map(0..(count - 1), &{x + &1, y - &1})
  defp neighbors({x, y}, count, :east), do: Enum.map(0..(count - 1), &{x + &1, y})
  defp neighbors({x, y}, count, :southeast), do: Enum.map(0..(count - 1), &{x + &1, y + &1})
  defp neighbors({x, y}, count, :south), do: Enum.map(0..(count - 1), &{x, y + &1})
  defp neighbors({x, y}, count, :southwest), do: Enum.map(0..(count - 1), &{x - &1, y + &1})
  defp neighbors({x, y}, count, :west), do: Enum.map(0..(count - 1), &{x - &1, y})
  defp neighbors({x, y}, count, :northwest), do: Enum.map(0..(count - 1), &{x - &1, y - &1})

  defp build_words(lists_of_neighbors, grid) do
    lists_of_neighbors
    |> Enum.map(fn neighbors ->
      neighbors
      |> Enum.map(&Map.get(grid, &1))
      |> Enum.join("")
    end)
  end

  defp build_crosses(chars, n) do
    chars
    |> Enum.reject(fn
      {0, _} -> true
      {_, 0} -> true
      {^n, _} -> true
      {_, ^n} -> true
      _ -> false
    end)
    |> Enum.map(fn {x, y} ->
      [
        {x - 1, y - 1},
        {x - 1, y + 1},
        {x, y},
        {x + 1, y - 1},
        {x + 1, y + 1}
      ]
    end)
  end
end
