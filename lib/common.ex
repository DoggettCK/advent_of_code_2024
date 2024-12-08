defmodule Common do
  def inspect_all(obj) do
    IO.inspect(obj, limit: :infinity, charlists: :as_lists, label: "Order")
  end

  def topological_sort(dependency_map) do
    graph = :digraph.new()

    Enum.each(dependency_map, fn {obj, deps} ->
      :digraph.add_vertex(graph, obj)

      Enum.each(deps, fn dep -> add_dependency(graph, obj, dep) end)
    end)

    :digraph_utils.topsort(graph)
  end

  defp add_dependency(_graph, l, l), do: :ok

  defp add_dependency(graph, l, dep) do
    :digraph.add_vertex(graph, dep)
    :digraph.add_edge(graph, dep, l)
  end
end
