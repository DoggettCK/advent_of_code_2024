defmodule Day22 do
  import Bitwise

  def part1(args) do
    args
    |> solve(2000)
  end

  def part2(_args) do
  end

  defp solve(initial_secrets, count) do
    initial_secrets
    |> List.flatten()
    |> Enum.flat_map(fn num ->
      num
      |> Stream.iterate(fn secret_number ->
        [
          &(&1 <<< 6),
          &(&1 >>> 5),
          &(&1 <<< 11)
        ]
        |> Enum.reduce(secret_number, fn mix_fn, acc ->
          mix_and_prune(acc, mix_fn)
        end)
      end)
      |> Stream.drop(count)
      |> Enum.take(1)
    end)
    |> Enum.sum()
  end

  defp mix_and_prune(secret_number, mix_fn) do
    secret_number
    |> mix_fn.()
    |> bxor(secret_number)
    |> prune()
  end

  defp prune(secret_number), do: rem(secret_number, 16_777_216)
end
