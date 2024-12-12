defmodule Day12 do
  import Common

  def part1(args) do
    %{grid: grid} = args

    regions =
      grid
      |> build_graph()
      |> Graph.components()

    regions
    |> Enum.map(&calculate_price(&1, grid))
    |> Enum.sum()
  end

  def part2(_args) do
  end

  defp build_graph(grid) do
    grid
    |> Enum.reduce(Graph.new(type: :undirected), fn {vertex, value}, graph ->
      graph = Graph.add_vertex(graph, vertex, value)

      neighbors =
        vertex
        |> cardinal_neighbors()
        |> then(&Map.take(grid, &1))
        |> Map.filter(fn
          {_, ^value} -> true
          _ -> false
        end)
        |> Map.keys()

      neighbors
      |> Enum.reduce(graph, fn neighbor, g ->
        g
        |> Graph.add_vertex(neighbor, value)
        |> Graph.add_edge(vertex, neighbor)
      end)
    end)
  end

  defp calculate_price(region, grid) do
    area = length(region)

    perimeter =
      region
      |> Enum.map(fn coord ->
        value = Map.get(grid, coord)

        coord
        |> cardinal_neighbors()
        |> Enum.into(%{}, &{&1, Map.get(grid, &1)})
        |> Map.filter(fn
          {_, ^value} -> false
          _ -> true
        end)
        |> map_size()
      end)
      |> Enum.sum()

    area * perimeter
  end
end
