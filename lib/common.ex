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

  def reject_from_grid(grid, values_to_remove) when is_list(values_to_remove) do
    Map.reject(grid, fn {_, v} -> v in values_to_remove end)
  end

  def reject_from_grid(grid, value_to_remove) do
    value_to_remove
    |> List.wrap()
    |> then(&reject_from_grid(grid, &1))
  end

  def filter_from_grid(grid, values_to_keep) when is_list(values_to_keep) do
    Map.filter(grid, fn {_, v} -> v in values_to_keep end)
  end

  def filter_from_grid(grid, value_to_keep) do
    value_to_keep
    |> List.wrap()
    |> then(&filter_from_grid(grid, &1))
  end

  def list_to_arraymap(list) do
    list
    |> Enum.with_index()
    |> Enum.into(%{}, fn {k, v} -> {v, k} end)
  end

  def cardinal_neighbors({x, y}) do
    [
      {x, y - 1},
      {x + 1, y},
      {x, y + 1},
      {x - 1, y}
    ]
  end

  def diagonal_neighbors({x, y}) do
    [
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y + 1}
    ]
  end

  def div_rem(n, x) do
    {div(n, x), rem(n, x)}
  end

  def filter_out_of_bounds(list, max_x, max_y) do
    Enum.filter(list, fn
      {x, _} when x < 0 or x > max_x -> false
      {_, y} when y < 0 or y > max_y -> false
      _ -> true
    end)
  end
end
