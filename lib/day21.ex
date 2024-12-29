defmodule Day21 do
  import Common

  @cache :day21_cache

  # 789
  # 456
  # 123
  #  0A
  @numeric_pad %{
    {0, 0} => "7",
    {1, 0} => "8",
    {2, 0} => "9",
    {0, 1} => "4",
    {1, 1} => "5",
    {2, 1} => "6",
    {0, 2} => "1",
    {1, 2} => "2",
    {2, 2} => "3",
    {1, 3} => "0",
    {2, 3} => "A"
  }

  #  ^A
  # <v>
  @directional_pad %{
    {1, 0} => "^",
    {2, 0} => "A",
    {0, 1} => "<",
    {1, 1} => "v",
    {2, 1} => ">"
  }

  def part1(codes) do
    solve(codes, 2)
  end

  def part2(codes) do
    solve(codes, 25)
  end

  defp solve(codes, depth) do
    numeric_paths = all_paths(@numeric_pad)
    directional_paths = all_paths(@directional_pad)

    codes
    |> Enum.map(fn code ->
      {numeric_part, _} = Integer.parse(code)

      numeric_part * find_cost(code, depth, numeric_paths, directional_paths)
    end)
    |> Enum.sum()
  end

  defp all_paths(map) do
    for a <- Map.keys(map),
        b <- Map.keys(map),
        a_char = Map.get(map, a),
        b_char = Map.get(map, b),
        paths = find_lowest_cost_paths(map, a, b) do
      {{a_char, b_char}, paths}
    end
    |> Enum.into(%{})
  end

  defp find_lowest_cost_paths(map, start, stop) do
    priority_queue =
      PriorityQueue.new()
      |> PriorityQueue.push({[start], 0}, 0)

    {priority_queue, %{}, nil, []}
    |> simulate(fn _iteration, {pq, seen, cost_at_goal, all_paths} ->
      case PriorityQueue.pop(pq) do
        {:empty, _} ->
          return(all_paths)

        {{:value, {path, cost}}, new_pq} ->
          location = List.last(path)

          cond do
            !is_nil(cost_at_goal) and cost > cost_at_goal ->
              return(all_paths)

            location == stop ->
              new_path =
                path
                |> pairwise(&diff_to_dir/2)
                |> Enum.join("")
                |> Kernel.<>("A")

              continue({new_pq, seen, cost, [new_path | all_paths]})

            Map.get(seen, location, 2 ** 32) >= cost ->
              new_seen = Map.put(seen, location, cost)

              new_queue =
                location
                |> cardinal_neighbors()
                |> Enum.filter(&Map.has_key?(map, &1))
                |> Enum.reduce(new_pq, fn neighbor, p_q ->
                  PriorityQueue.push(p_q, {path ++ [neighbor], cost + 1}, cost + 1)
                end)

              continue({new_queue, new_seen, cost_at_goal, all_paths})

            true ->
              continue({new_pq, seen, cost_at_goal, all_paths})
          end
      end
    end)
  end

  defp minus({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}

  defp diff_to_dir(a, b) do
    case minus(b, a) do
      {0, -1} -> "^"
      {1, 0} -> ">"
      {0, 1} -> "v"
      {-1, 0} -> "<"
    end
  end

  defp find_cost(code, depth, transition_paths, directional_paths) do
    cache_key = {code, depth}

    case Cachex.exists?(@cache, cache_key) do
      {:ok, true} ->
        {:ok, cached} = Cachex.get(@cache, cache_key)

        cached

      _ ->
        result =
          ("A" <> code)
          |> pairwise(fn a, b ->
            paths = Map.get(transition_paths, {a, b})

            if depth == 0 do
              paths
              |> Enum.min_by(&String.length/1)
              |> String.length()
            else
              paths
              |> Enum.map(&find_cost(&1, depth - 1, directional_paths, directional_paths))
              |> Enum.min()
            end
          end)
          |> Enum.sum()

        Cachex.put(@cache, cache_key, result)

        result
    end
  end
end
