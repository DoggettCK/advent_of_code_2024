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

    start = grid |> grid_positions("S") |> hd()
    stop = grid |> grid_positions("E") |> hd()

    traverse_maze(grid, start, stop)
  end

  def part2(_args) do
  end

  defp traverse_maze(grid, start, stop) do
    starting_location = %Location{position: start, positions: [start]}

    {PriorityQueue.new() |> PriorityQueue.push({starting_location, 0}, 0), %{}}
    |> simulate(fn _iteration, {pq, seen} ->
      case PriorityQueue.pop(pq) do
        {{:value, {%Location{position: ^stop}, cost}}, _pq} ->
          {:halt, cost}

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

            {:cont, {new_pq, seen}}
          else
            {:cont, {new_pq, seen}}
          end

        other ->
          IO.inspect(other, label: "UNKNOWN STATE")
      end
    end)
  end
end
