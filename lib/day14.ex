defmodule Day14 do
  import Common

  def part1(args, bounds) do
    {max_x, max_y} = bounds

    mid_x = div(max_x, 2)
    mid_y = div(max_y, 2)

    args
    |> build_robots()
    |> run_simulation(100, bounds)
    |> Enum.reject(fn
      %{pos: {^mid_x, _}} -> true
      %{pos: {_, ^mid_y}} -> true
      _ -> false
    end)
    |> Enum.group_by(
      &{
        elem(&1.pos, 0) < mid_x,
        elem(&1.pos, 1) < mid_y
      }
    )
    |> Map.values()
    |> Enum.map(&length/1)
    |> Enum.product()
  end

  def part2(args, bounds) do
    {max_x, max_y} = bounds

    args
    |> build_robots()
    |> run_tree_simulation(max_x * max_y, bounds)
  end

  defp build_robots(ints) do
    Enum.map(ints, fn [px, py, vx, vy] ->
      %{pos: {px, py}, vel: {vx, vy}}
    end)
  end

  defp run_simulation(robots, iterations, bounds) do
    robots
    |> simulate(fn
      ^iterations, state ->
        {:halt, state}

      _, state ->
        new_state = move_robots(state, bounds)

        {:cont, new_state}
    end)
  end

  defp run_tree_simulation(robots, iterations, bounds) do
    {robots, 2 * length(robots), -1}
    |> simulate(fn
      ^iterations, {_bots, _lc, lc_iteration} ->
        # Convert from zero-based to one-based for seconds elapsed
        {:halt, lc_iteration + 1}

      iteration, {bots, least_components, lc_iteration} ->
        new_robots = move_robots(bots, bounds)

        graph = build_graph(new_robots)

        num_components = graph |> Graph.components() |> length()

        if num_components < least_components do
          {:cont, {new_robots, num_components, iteration}}
        else
          {:cont, {new_robots, least_components, lc_iteration}}
        end
    end)
  end

  defp build_graph(robots) do
    # For every robot, add an edge to any neighbor that also contains a robot.
    # Then we'll break it into components, and the graph with the smallest
    # number of components (ideally 2) will be the tree shape.
    robot_map = Enum.into(robots, %{}, &{&1.pos, "#"})

    robot_map
    |> Enum.reduce(Graph.new(type: :undirected), fn {pos, _}, outer_g ->
      pos
      |> cardinal_neighbors()
      |> Enum.filter(&Map.has_key?(robot_map, &1))
      |> Enum.reduce(outer_g, fn neighbor, inner_g ->
        # weight is always 1 since they're cardinal neighbors
        Graph.add_edge(inner_g, pos, neighbor)
      end)
    end)
  end

  defp move_robots(robots, {max_x, max_y}) do
    Enum.map(robots, fn %{pos: {px, py}, vel: {vx, vy}} = robot ->
      %{robot | pos: {constrain(px + vx, max_x), constrain(py + vy, max_y)}}
    end)
  end

  defp constrain(val, max) when val < 0, do: val + max
  defp constrain(val, max) when val >= max, do: val - max
  defp constrain(val, _), do: val
end
