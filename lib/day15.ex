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

  def part2(grid, dirs) do
    %{grid: grid} = grid

    grid
    |> grid_positions("@")
    |> hd()
    |> do_movements(dirs, grid)
    |> grid_positions("[")
    |> Enum.map(&gps/1)
    |> Enum.sum()
  end

  defp do_movements(pos, dirs, grid) do
    dirs
    |> Enum.reduce({pos, grid}, fn dir, {place, warehouse} ->
      next_pos = next_position(place, dir)

      case Map.get(warehouse, next_pos) do
        c when c in ["[", "O", "]"] ->
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
    {:queue.from_list([position]), MapSet.new(), []}
    |> simulate(fn _iterations, {queue, seen, safe_pushes} ->
      if :queue.is_empty(queue) do
        {:halt, safe_pushes}
      else
        {{:value, current_pos}, queue} = :queue.out(queue)

        if current_pos in seen do
          {:cont, {queue, seen, safe_pushes}}
        else
          seen = MapSet.put(seen, current_pos)

          next_pos = next_position(current_pos, direction)

          queue =
            case {direction, Map.get(grid, current_pos)} do
              {"^", "]"} ->
                current_pos
                |> next_position("<")
                |> :queue.in(queue)

              {"v", "]"} ->
                current_pos
                |> next_position("<")
                |> :queue.in(queue)

              {"^", "["} ->
                current_pos
                |> next_position(">")
                |> :queue.in(queue)

              {"v", "["} ->
                current_pos
                |> next_position(">")
                |> :queue.in(queue)

              _ ->
                queue
            end

          case Map.get(grid, next_pos) do
            "#" ->
              {:halt, []}

            c when c in ["[", "O", "]"] ->
              {:cont, {:queue.in(next_pos, queue), seen, [{current_pos, next_pos} | safe_pushes]}}

            _ ->
              {:cont, {queue, seen, [{current_pos, next_pos} | safe_pushes]}}
          end
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
