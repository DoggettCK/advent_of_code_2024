defmodule Day06 do
  import Common

  def part1(args) do
    grid =
      args
      |> Map.reject(fn
        {_, "."} -> true
        _ -> false
      end)

    {guard_pos, guard_dir} = get_initial_guard_position(grid)
    {max_x, grid} = Map.pop(grid, :max_x)
    {max_y, grid} = Map.pop(grid, :max_y)

    %{
      grid: grid,
      max_x: max_x,
      max_y: max_y,
      guard_pos: guard_pos,
      guard_dir: guard_dir
    }
    |> simulate(&run_simulation/2)
    |> Map.get(:grid)
    |> Map.filter(fn
      {_, "X"} -> true
      _ -> false
    end)
    |> map_size()
  end

  def part2(_args) do
  end

  defp get_initial_guard_position(grid) do
    coords =
      grid
      |> Map.filter(fn
        {_, "^"} -> true
        _ -> false
      end)
      |> Map.keys()
      |> hd()

    {coords, :north}
  end

  defp run_simulation(_iteration, state) do
    %{
      grid: grid,
      guard_pos: guard_pos
    } = state

    case next_action(state) do
      {:turn, new_guard_dir} ->
        {:cont, %{state | guard_dir: new_guard_dir}}

      {:step, new_location} ->
        {:cont, %{state | grid: Map.put(grid, guard_pos, "X"), guard_pos: new_location}}

      {:halt, new_location} ->
        {:halt, %{state | grid: Map.put(grid, guard_pos, "X"), guard_pos: new_location}}
    end
  end

  defp next_action(state) do
    %{
      grid: grid,
      max_x: max_x,
      max_y: max_y,
      guard_pos: guard_pos,
      guard_dir: guard_dir
    } = state

    {next_x, next_y} = next_location(guard_pos, guard_dir)

    cond do
      Map.get(grid, {next_x, next_y}) == "#" ->
        {:turn, turn_right(guard_dir)}

      next_x < 0 ->
        {:halt, {next_x, next_y}}

      next_y < 0 ->
        {:halt, {next_x, next_y}}

      next_x > max_x ->
        {:halt, {next_x, next_y}}

      next_y > max_y ->
        {:halt, {next_x, next_y}}

      true ->
        {:step, {next_x, next_y}}
    end
  end

  defp next_location({x, y}, :north), do: {x, y - 1}
  defp next_location({x, y}, :east), do: {x + 1, y}
  defp next_location({x, y}, :south), do: {x, y + 1}
  defp next_location({x, y}, :west), do: {x - 1, y}

  defp turn_right(:north), do: :east
  defp turn_right(:east), do: :south
  defp turn_right(:south), do: :west
  defp turn_right(:west), do: :north
end
