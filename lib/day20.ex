defmodule Day20 do
  import Common

  def part1(args, savings_goal) do
    %{grid: grid} = args

    grid
    |> find_path()
    |> find_cheats(savings_goal, 2)
  end

  def part2(args, savings_goal) do
    %{grid: grid} = args

    grid
    |> find_path()
    |> find_cheats(savings_goal, 20)
  end

  defp find_path(grid) do
    start = find_single(grid, "S")
    stop = find_single(grid, "E")

    {[start], MapSet.new([start])}
    |> simulate(fn _i, {[last | _] = stack, seen} ->
      case last do
        ^stop ->
          return(Enum.reverse(stack))

        _ ->
          next =
            last
            |> cardinal_neighbors()
            |> Enum.filter(&(Map.get(grid, &1) in ["S", "E", "."]))
            |> Enum.reject(&(&1 in seen))
            |> hd

          continue({[next | stack], MapSet.put(seen, next)})
      end
    end)
    |> list_to_arraymap()
  end

  def find_cheats(path_map, savings_goal, cheat_time) do
    last_index = map_size(path_map) - 1

    0..last_index
    |> Enum.map(fn start ->
      (start + savings_goal)..last_index
      |> Stream.reject(&(&1 > last_index))
      |> Enum.filter(fn stop ->
        s = Map.get(path_map, start)
        e = Map.get(path_map, stop)

        dist = manhattan_distance(s, e)

        cond do
          dist > cheat_time ->
            false

          dist > stop - start - savings_goal ->
            false

          true ->
            true
        end
      end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end
end
