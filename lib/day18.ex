defmodule Day18 do
  import Common

  def part1(args, n, byte_count) do
    corrupt_bytes = corrupt_bytes(args)

    corrupt_bytes
    |> Enum.take(byte_count)
    |> MapSet.new()
    |> traverse(n)
  end

  def part2(args, n) do
    index =
      args
      |> corrupt_bytes()
      |> find_first_nil(fn bytes, i ->
        bytes
        |> Enum.take(i)
        |> MapSet.new()
        |> traverse(n)
      end)

    args
    |> Enum.at(index - 1)
    |> Enum.join(",")
  end

  defp corrupt_bytes(args) do
    Enum.map(args, &List.to_tuple/1)
  end

  defp traverse(corrupt, n) do
    goal = {n, n}

    {:queue.from_list([{{0, 0}, 0}]), MapSet.new()}
    |> simulate(fn _iterations, {queue, seen} ->
      if :queue.is_empty(queue) do
        return(nil)
      else
        {{:value, {current_pos, cost}}, queue} = :queue.out(queue)

        case current_pos do
          ^goal ->
            return(cost)

          _ ->
            if current_pos in seen do
              continue({queue, seen})
            else
              new_queue =
                current_pos
                |> cardinal_neighbors()
                |> Enum.filter(fn
                  {x, y} when x in 0..n and y in 0..n ->
                    true

                  _ ->
                    false
                end)
                |> Enum.reject(&MapSet.member?(corrupt, &1))
                |> Enum.reduce(queue, &:queue.in({&1, cost + 1}, &2))

              continue({new_queue, MapSet.put(seen, current_pos)})
            end
        end
      end
    end)
  end

  defp find_first_nil(corrupt_bytes, eval_func) do
    {0, length(corrupt_bytes), nil}
    |> simulate(fn _i, {low, high, first_nil} ->
      if high < low do
        return(first_nil)
      else
        mid = div(low + high, 2)

        case eval_func.(corrupt_bytes, mid) do
          nil ->
            # No path found, too many bytes added
            continue({low, mid - 1, mid})

          _ ->
            # Found path, can still add more
            continue({mid + 1, high, first_nil})
        end
      end
    end)
  end
end
