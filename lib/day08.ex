defmodule Day08 do
  import Common
  import Combinatorics, only: [n_combinations: 2]

  def part1(args) do
    %{grid: grid} = args

    %{args | grid: reject_from_grid(grid, ".")}
    |> build_antinodes(&part_1_antinodes/5)
    |> length()
  end

  def part2(args) do
    %{grid: grid} = args

    %{args | grid: reject_from_grid(grid, ".")}
    |> build_antinodes(&part_2_antinodes/5)
    |> length()
  end

  defp minus({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}
  defp plus({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp build_antinodes(args, count_func) when is_function(count_func, 5) do
    %{grid: grid, max_x: max_x, max_y: max_y} = args

    grid
    |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
    |> Map.values()
    |> Enum.flat_map(fn node_list ->
      2
      |> n_combinations(node_list)
      |> Enum.flat_map(fn [a, b] -> count_func.(a, b, minus(a, b), max_x, max_y) end)
    end)
    |> MapSet.new()
    |> MapSet.to_list()
  end

  defp part_1_antinodes(a, b, diff_a_b, max_x, max_y) do
    [plus(a, diff_a_b), minus(b, diff_a_b)]
    |> filter_out_of_bounds(max_x, max_y)
  end

  defp part_2_antinodes(a, b, diff_a_b, max_x, max_y) do
    from_a =
      a
      |> Stream.iterate(&plus(&1, diff_a_b))
      |> take_while_in_bounds(max_x, max_y)

    from_b =
      b
      |> Stream.iterate(&minus(&1, diff_a_b))
      |> take_while_in_bounds(max_x, max_y)

    from_a ++ from_b
  end

  defp take_while_in_bounds(iter, max_x, max_y) do
    iter
    |> Enum.take_while(fn
      {x, _} when x < 0 or x > max_x -> false
      {_, y} when y < 0 or y > max_y -> false
      _ -> true
    end)
  end
end
