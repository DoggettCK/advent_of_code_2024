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

  def part2(_args) do
  end

  defp build_robots(ints) do
    Enum.map(ints, fn [px, py, vx, vy] ->
      %{pos: {px, py}, vel: {vx, vy}}
    end)
  end

  defp run_simulation(robots, iterations, bounds) do
    robots
    |> simulate(fn
      100, state ->
        {:halt, state}

      ^iterations, state ->
        {:halt, state}

      _, state ->
        new_state = move_robots(state, bounds)

        {:cont, new_state}
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
