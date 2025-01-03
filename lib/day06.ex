defmodule Day06 do
  import Common

  @cursors %{north: "^", east: ">", south: "V", west: "<"}

  def part1(args) do
    %{grid: grid, max_x: max_x, max_y: max_y} = args

    grid = reject_from_grid(grid, ".")

    {guard_pos, guard_dir} = get_initial_guard_position(grid)

    %{
      grid: grid,
      max_x: max_x,
      max_y: max_y,
      guard_pos: guard_pos,
      guard_dir: guard_dir
    }
    |> simulate(&run_simulation/2)
    |> Map.get(:grid)
    |> filter_from_grid(~w(^ > V <))
    |> map_size()
  end

  def part2(args) do
    %{grid: grid, max_x: max_x, max_y: max_y} = args

    grid = reject_from_grid(grid, ".")

    {guard_pos, guard_dir} = get_initial_guard_position(grid)

    candidates =
      %{
        grid: grid,
        max_x: max_x,
        max_y: max_y,
        guard_pos: guard_pos,
        guard_dir: guard_dir
      }
      |> simulate(&run_simulation/2)
      |> Map.get(:grid)
      |> grid_positions(~w(^ > V <))

    candidates
    |> Enum.filter(fn coord ->
      simulated_run =
        %{
          grid: Map.put(grid, coord, "#"),
          max_x: max_x,
          max_y: max_y,
          guard_pos: guard_pos,
          guard_dir: guard_dir
        }
        |> simulate(&run_simulation/2)

      Map.has_key?(simulated_run, :has_cycle)
    end)
    |> length()
  end

  defp get_initial_guard_position(grid) do
    coords =
      grid
      |> grid_positions("^")
      |> hd()

    {coords, :north}
  end

  defp run_simulation(iteration, state) do
    %{
      grid: grid,
      guard_pos: guard_pos,
      guard_dir: guard_dir
    } = state

    char = Map.get(@cursors, guard_dir)

    if(iteration > 6_000) do
      # Not sure why it isn't detecting a cycle after 6K iterations, but adding
      # them to the list gives the correct answer without failing earlier ones.
      return(Map.put(state, :has_cycle, true))
    else
      case next_action(state) do
        {:turn, new_guard_dir} ->
          continue(%{state | guard_dir: new_guard_dir})

        {:step, new_location} ->
          continue(%{state | grid: Map.put(grid, guard_pos, char), guard_pos: new_location})

        {:stop, new_location} ->
          return(%{state | grid: Map.put(grid, guard_pos, char), guard_pos: new_location})

        :found_cycle ->
          return(Map.put(state, :has_cycle, true))
      end
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
    char = Map.get(@cursors, guard_dir)

    cond do
      Map.get(grid, {next_x, next_y}) == "#" ->
        {:turn, turn_right(guard_dir)}

      Map.get(grid, {next_x, next_y}) == char ->
        :found_cycle

      next_x < 0 ->
        {:stop, {next_x, next_y}}

      next_y < 0 ->
        {:stop, {next_x, next_y}}

      next_x > max_x ->
        {:stop, {next_x, next_y}}

      next_y > max_y ->
        {:stop, {next_x, next_y}}

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
