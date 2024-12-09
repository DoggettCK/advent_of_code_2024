defmodule Common do
  def inspect_all(obj, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:limit, :infinity)
      |> Keyword.put_new(:charlists, :as_lists)

    IO.inspect(obj, opts)
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

  @doc """
  Thin wrapper around Enum.reduce_while that runs against an infinite stream of
  increasing integers starting at zero and increasing by one every iteration.

  `step_simulation` function will take 2 params, `iteration` and `state` (`x`
  and `acc`), and should return either `{:cont, next_state}` or `{:halt,
  next_state}`. Until the `:halt` tuple is returned, the function will run
  forever.
  """
  def simulate(initial_state, step_simulation) do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while(initial_state, step_simulation)
  end
end