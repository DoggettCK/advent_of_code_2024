defmodule Day18 do
  import Common

  def part1(args, n, byte_count) do
    n
    |> build_initial_map()
    |> corrupt_map(args, byte_count)
    |> build_graph_from_corrupted_map()
    |> Graph.Pathfinding.dijkstra({0, 0}, {n, n})
    |> length()
    |> Kernel.-(1)
  end

  def part2(_args) do
  end

  defp build_initial_map(n) do
    for x <- 0..n, y <- 0..n do
      {x, y}
    end
    |> Enum.into(%{}, fn k -> {k, "."} end)
  end

  defp corrupt_map(map, input, byte_count) do
    input
    |> Enum.take(byte_count)
    |> Enum.reduce(map, fn [x, y], acc -> Map.put(acc, {x, y}, "#") end)
  end

  defp build_graph_from_corrupted_map(map) do
    map
    |> filter_from_grid(".")
    |> Map.keys()
    |> Enum.reduce(Graph.new(type: :undirected), fn coord, graph ->
      coord
      |> cardinal_neighbors()
      |> then(&Map.take(map, &1))
      |> filter_from_grid(".")
      |> Enum.reduce(graph, &Graph.add_edge(&2, coord, elem(&1, 0)))
    end)
  end
end
