defmodule Day23 do
  import Combinatorics, only: [n_combinations: 2]

  def part1(args) do
    args
    |> build_graph()
    |> Graph.cliques()
    |> Enum.flat_map(&find_triplets/1)
    |> Enum.map(&Enum.sort/1)
    |> Enum.sort()
    |> Enum.filter(fn clique ->
      Enum.any?(clique, &String.starts_with?(&1, "t"))
    end)
    |> Enum.uniq_by(&Enum.sort/1)
    |> length()
  end

  def part2(args) do
    args
    |> build_graph()
    |> Graph.cliques()
    |> Enum.max_by(&length/1)
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp build_graph(connections) do
    connections
    |> Enum.reduce(Graph.new(type: :undirected), fn connection, graph ->
      connection
      |> String.split("-")
      |> then(&apply(Graph, :add_edge, [graph | &1]))
    end)
  end

  defp find_triplets(clique) when length(clique) < 3, do: []
  defp find_triplets([_, _, _] = clique), do: [clique]

  defp find_triplets(clique) do
    n_combinations(3, clique)
  end
end
