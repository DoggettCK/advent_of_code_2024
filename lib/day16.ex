defmodule Day16 do
  import Common

  @default_cost 2 ** 32

  defmodule Location do
    @north {0, -1}
    @east {1, 0}
    @south {0, 1}
    @west {-1, 0}

    defstruct position: nil, positions: [], direction: @east

    def key(%Location{} = location) do
      {location.position, location.direction}
    end

    def step(%Location{} = location) do
      next_pos = add(location.position, location.direction)

      %Location{location | position: next_pos, positions: [next_pos | location.positions]}
    end

    def turn_clockwise(%Location{} = location) do
      %Location{location | direction: clockwise(location.direction)}
    end

    def turn_counter_clockwise(%Location{} = location) do
      %Location{location | direction: counter_clockwise(location.direction)}
    end

    defp clockwise(@east), do: @south
    defp clockwise(@south), do: @west
    defp clockwise(@west), do: @north
    defp clockwise(@north), do: @east

    defp counter_clockwise(@east), do: @north
    defp counter_clockwise(@north), do: @west
    defp counter_clockwise(@west), do: @south
    defp counter_clockwise(@south), do: @east
  end

  def part1(args) do
    %{grid: grid} = args

    start = find_single(grid, "S")
    stop = find_single(grid, "E")

    traverse_maze(grid, start, stop)
  end

  def part2(args) do
    %{grid: grid} = args

    start = find_single(grid, "S")
    stop = find_single(grid, "E")

    traverse_maze_with_path(grid, start, stop)
  end

  defp traverse_maze(grid, start, stop) do
    starting_location = %Location{position: start, positions: [start]}

    {PriorityQueue.new() |> PriorityQueue.push({starting_location, 0}, 0), %{}}
    |> simulate(fn _iteration, {pq, seen} ->
      case PriorityQueue.pop(pq) do
        {{:value, {%Location{position: ^stop}, cost}}, _pq} ->
          return(cost)

        {{:value, {location, cost}}, new_pq} ->
          key = Location.key(location)

          if Map.get(seen, key, @default_cost) > cost do
            seen = Map.put(seen, key, cost)

            next_location = Location.step(location)

            new_pq =
              grid
              |> Map.get(next_location.position)
              |> case do
                "#" -> new_pq
                _ -> PriorityQueue.push(new_pq, {next_location, cost + 1}, cost + 1)
              end
              |> PriorityQueue.push({Location.turn_clockwise(location), cost + 1000}, cost + 1000)
              |> PriorityQueue.push(
                {Location.turn_counter_clockwise(location), cost + 1000},
                cost + 1000
              )

            continue({new_pq, seen})
          else
            continue({new_pq, seen})
          end

        other ->
          IO.inspect(other, label: "UNKNOWN STATE")
      end
    end)
  end

  defp traverse_maze_with_path(grid, start, stop) do
    starting_location = %Location{position: start, positions: [start]}

    {
      PriorityQueue.new() |> PriorityQueue.push({starting_location, 0}, 0),
      %{},
      nil,
      MapSet.new()
    }
    |> simulate(fn _iteration, {pq, seen, goal_cost, all_spots} ->
      case PriorityQueue.pop(pq) do
        {:empty, _} ->
          return(MapSet.size(all_spots))

        {{:value, {location, cost}}, new_pq} ->
          if !is_nil(goal_cost) and cost > goal_cost do
            return(MapSet.size(all_spots))
          else
            if location.position == stop do
              continue({
                new_pq,
                seen,
                cost,
                location.positions
                |> MapSet.new()
                |> MapSet.union(all_spots)
              })
            else
              key = Location.key(location)

              if Map.get(seen, key, @default_cost) >= cost do
                seen = Map.put(seen, key, cost)

                next_location = Location.step(location)

                new_pq =
                  grid
                  |> Map.get(next_location.position)
                  |> case do
                    "#" -> new_pq
                    _ -> PriorityQueue.push(new_pq, {next_location, cost + 1}, cost + 1)
                  end
                  |> PriorityQueue.push(
                    {Location.turn_clockwise(location), cost + 1000},
                    cost + 1000
                  )
                  |> PriorityQueue.push(
                    {Location.turn_counter_clockwise(location), cost + 1000},
                    cost + 1000
                  )

                continue({new_pq, seen, goal_cost, all_spots})
              else
                continue({new_pq, seen, goal_cost, all_spots})
              end
            end
          end
      end
    end)
  end
end
