defmodule Day13 do
  def part1(args) do
    args
    |> Enum.chunk_every(3)
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> Enum.chunk_every(3)
    |> Enum.map(&solve(&1, 10_000_000_000_000))
    |> Enum.sum()
  end

  defp solve([[a_x, a_y], [b_x, b_y], [target_x, target_y]], offset \\ 0) do
    target_x = target_x + offset
    target_y = target_y + offset

    b_presses = div(target_x * a_y - a_x * target_y, a_y * b_x - b_y * a_x)
    a_presses = div(target_x - b_presses * b_x, a_x)

    case {a_presses * a_x + b_presses * b_x, a_presses * a_y + b_presses * b_y} do
      {^target_x, ^target_y} ->
        3 * a_presses + b_presses

      _ ->
        0
    end
  end
end
