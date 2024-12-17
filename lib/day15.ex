defmodule Day15 do
  import Common

  def part1(grid, dirs) do
    %{grid: grid} = grid

    grid
    |> grid_positions("@")
    |> hd()
    |> do_movements(dirs, grid)
    |> grid_positions("O")
    |> Enum.map(&gps/1)
    |> Enum.sum()
  end

  def part2(_grid, _dirs) do
  end

  defp do_movements(pos, dirs, grid) do
    dirs
    |> Enum.reduce({pos, grid}, fn dir, {place, warehouse} ->
      next_pos = next_position(place, dir)

      case Map.get(warehouse, next_pos) do
        "O" ->
          next_pos
          |> push(dir, warehouse)
          |> case do
            [] ->
              {place, warehouse}

            moves ->
              {
                next_pos,
                moves
                |> Enum.reduce(warehouse, fn {from, to}, acc ->
                  acc
                  |> Map.put(to, Map.get(acc, from))
                  |> Map.put(from, ".")
                end)
                |> Map.put(next_pos, "@")
                |> Map.put(place, ".")
              }
          end

        "#" ->
          # at wall, stay still
          {place, warehouse}

        _ ->
          {
            next_pos,
            warehouse
            |> Map.put(next_pos, "@")
            |> Map.put(place, ".")
          }
      end
    end)
    |> elem(1)
  end

  defp push(position, direction, grid) do
    {:queue.from_list([position]), []}
    |> simulate(fn _iterations, {queue, safe_pushes} ->
      if :queue.is_empty(queue) do
        {:halt, safe_pushes}
      else
        {{:value, current_pos}, queue} = :queue.out(queue)

        next_pos = next_position(current_pos, direction)

        case Map.get(grid, next_pos) do
          "#" ->
            {:halt, []}

          "O" ->
            {:cont, {:queue.in(next_pos, queue), [{current_pos, next_pos} | safe_pushes]}}

          _ ->
            {:cont, {queue, [{current_pos, next_pos} | safe_pushes]}}
        end
      end
    end)
  end

  defp gps({x, y}), do: 100 * y + x

  defp next_position(current_pos, "<"), do: add(current_pos, {-1, 0})
  defp next_position(current_pos, "^"), do: add(current_pos, {0, -1})
  defp next_position(current_pos, ">"), do: add(current_pos, {1, 0})
  defp next_position(current_pos, "v"), do: add(current_pos, {0, 1})
  defp next_position(current_pos, _), do: current_pos
end
