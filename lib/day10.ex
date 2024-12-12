defmodule Day10 do
  import Common

  def part1(args) do
    %{grid: grid} = args

    grid
    |> filter_from_grid(0)
    |> Map.keys()
    |> Enum.map(&find_paths(&1, args, true))
    |> Enum.sum()
  end

  def part2(args) do
    %{grid: grid} = args

    grid
    |> filter_from_grid(0)
    |> Map.keys()
    |> Enum.map(&find_paths(&1, args, false))
    |> Enum.sum()
  end

  defp find_paths(node, args, track_seen) do
    %{grid: grid, max_x: max_x, max_y: max_y} = args

    {:queue.from_list([node]), MapSet.new(), 0}
    |> simulate(fn _iteration, {queue, seen, found} ->
      if :queue.is_empty(queue) do
        {:halt, found}
      else
        {{:value, node}, queue} = :queue.out(queue)

        if node in seen do
          {:cont, {queue, seen, found}}
        else
          seen =
            if track_seen do
              MapSet.put(seen, node)
            else
              seen
            end

          case Map.get(grid, node) do
            9 ->
              {:cont, {queue, seen, found + 1}}

            level ->
              neighbors =
                node
                |> cardinal_neighbors()
                |> limit_to_grid(max_x, max_y)
                |> Enum.filter(fn n -> Map.get(grid, n) == level + 1 end)
                |> :queue.from_list()

              {:cont, {:queue.join(queue, neighbors), seen, found}}
          end
        end
      end
    end)
  end

  defp limit_to_grid(nodes, max_x, max_y) do
    Enum.reject(nodes, fn
      {x, _} when x < 0 or x > max_x -> true
      {_, y} when y < 0 or y > max_y -> true
      _ -> false
    end)
  end
end
