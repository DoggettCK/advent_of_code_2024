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
  forever. The `return/1` and `continue/1` helpers will wrap these for you to
  be more like imperative languages.
  """
  def simulate(initial_state, step_simulation) do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while(initial_state, step_simulation)
  end

  # helpers for Enum.reduce_while/simulate
  def return(value), do: {:halt, value}
  def continue(value), do: {:cont, value}

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

  def find_single(grid, value) do
    grid
    |> grid_positions(value)
    |> hd()
  end

  def grid_positions(grid, value) do
    grid
    |> filter_from_grid(value)
    |> Map.keys()
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

  def directional_neighbors({x, y}) do
    %{
      north: {x, y - 1},
      east: {x + 1, y},
      south: {x, y + 1},
      west: {x - 1, y},
      northwest: {x - 1, y - 1},
      northeast: {x + 1, y - 1},
      southwest: {x - 1, y + 1},
      southeast: {x + 1, y + 1}
    }
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

  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def grid_to_string(grid, default \\ ".") do
    {{min_x, min_y}, _} = Enum.min_by(grid, &elem(&1, 0))
    {{max_x, max_y}, _} = Enum.max_by(grid, &elem(&1, 0))

    min_y..max_y
    |> Enum.map(fn row ->
      min_x..max_x
      |> Enum.map(fn col ->
        Map.get(grid, {col, row}, default)
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end

  def print_grid(grid) do
    grid
    |> grid_to_string()
    |> IO.puts()

    grid
  end

  def tails(list) do
    list
    |> Enum.reverse()
    |> do_tails([[]])
  end

  defp do_tails([], results), do: results

  defp do_tails([h | t], [last | _] = results) do
    do_tails(t, [[h | last] | results])
  end

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)

  def pairs(list) when is_list(list) do
    Enum.chunk_every(list, 2, 1, :discard)
  end

  def pairs(str) when is_binary(str) do
    str
    |> String.graphemes()
    |> pairs()
  end

  def pairwise(val, func) when is_list(val) or (is_binary(val) and is_function(func, 2)) do
    val
    |> pairs()
    |> Enum.map(fn [a, b] ->
      func.(a, b)
    end)
  end

  def shortest_paths(graph, v1, v2) do
    {_, paths} =
      graph
      |> Graph.Pathfinding.all(v1, v2)
      |> Enum.group_by(&length/1)
      |> Enum.min_by(&elem(&1, 0))

    paths
  end

  def build_grid_from_lines(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_idx}, acc ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.into(acc, fn {char, col_idx} ->
        {{col_idx, row_idx}, char}
      end)
    end)
  end

  def swap_map(map, a, b) when is_map_key(map, a) and is_map_key(map, b) do
    a_val = Map.get(map, a)
    b_val = Map.get(map, b)

    map
    |> Map.put(a, b_val)
    |> Map.put(b, a_val)
  end
end
