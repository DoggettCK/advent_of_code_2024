defmodule Day14 do
  import Common
  import Statistics, only: [variance: 1]

  def part1(args, bounds) do
    {max_width, max_height} = bounds

    mid_x = div(max_width, 2)
    mid_y = div(max_height, 2)

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
    {max_width, max_height} = bounds

    max_time = max(max_width, max_height)

    {build_robots(args), [], []}
    |> simulate(fn
      ^max_time, {_, x_variances, y_variances} ->
        {_, best_x} =
          x_variances
          |> Enum.reverse()
          |> Enum.with_index(1)
          |> Enum.min_by(&elem(&1, 0))

        {_, best_y} =
          y_variances
          |> Enum.reverse()
          |> Enum.with_index(1)
          |> Enum.min_by(&elem(&1, 0))

        {:ok, inv} = Math.mod_inv(max_width, max_height)

        (best_x + rem(inv * (best_y - best_x), max_height) * max_width)
        # actual answer is negative, so constrain it to bounds of grid
        |> Kernel.+(max_width * max_height)
        |> rem(max_width * max_height)
        |> return()

      _, {robots, x_variances, y_variances} ->
        new_robots = move_robots(robots, bounds)

        {xs, ys} =
          new_robots
          |> Enum.map(& &1.pos)
          |> Enum.unzip()

        continue({new_robots, [variance(xs) | x_variances], [variance(ys) | y_variances]})
    end)
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
        return(state)

      _, state ->
        state
        |> move_robots(bounds)
        |> continue()
    end)
  end

  defp move_robots(robots, {max_width, max_height}) do
    Enum.map(robots, fn %{pos: {px, py}, vel: {vx, vy}} = robot ->
      %{robot | pos: {constrain(px + vx, max_width), constrain(py + vy, max_height)}}
    end)
  end

  defp constrain(val, max) when val < 0, do: val + max
  defp constrain(val, max) when val >= max, do: val - max
  defp constrain(val, _), do: val
end
