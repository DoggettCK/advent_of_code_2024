defmodule Day11 do
  import Common

  @cache :day11_cache

  def part1(args) do
    args
    |> Enum.map(&blink(&1, 25))
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> Enum.map(&blink(&1, 75))
    |> Enum.sum()
  end

  defp blink(_stone, 0), do: 1

  defp blink(stone, remaining) do
    key = {stone, remaining}

    case Cachex.exists?(@cache, key) do
      {:ok, true} ->
        @cache
        |> Cachex.get(key)
        |> elem(1)

      _ ->
        result =
          if stone == 0 do
            blink(1, remaining - 1)
          else
            {d, r} =
              stone
              |> Integer.digits()
              |> length()
              |> div_rem(2)

            case r do
              0 ->
                stone
                |> div_rem(10 ** d)
                |> Tuple.to_list()
                |> Enum.map(&blink(&1, remaining - 1))
                |> Enum.sum()

              _ ->
                blink(stone * 2024, remaining - 1)
            end
          end

        {:ok, true} = Cachex.put(@cache, key, result)

        result
    end
  end
end
