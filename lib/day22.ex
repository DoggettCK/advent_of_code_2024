defmodule Day22 do
  import Bitwise
  import Common

  def part1(initial_secrets) do
    initial_secrets
    |> List.flatten()
    |> Enum.flat_map(fn num ->
      num
      |> Stream.iterate(&next_number/1)
      |> Stream.drop(2000)
      |> Enum.take(1)
    end)
    |> Enum.sum()
  end

  def part2(initial_secrets) do
    initial_secrets
    |> List.flatten()
    |> Stream.map(fn num ->
      num
      |> Stream.iterate(&next_number/1)
      |> Stream.take(2001)
      |> Stream.map(&rem(&1, 10))
    end)
    |> Enum.reduce(%{}, fn sequence, acc ->
      sequence
      |> Stream.chunk_every(5, 1, :discard)
      |> Stream.map(fn chunk ->
        deltas =
          chunk
          |> pairwise(fn a, b -> b - a end)

        value = List.last(chunk)

        {deltas, value}
      end)
      |> Stream.uniq_by(&elem(&1, 0))
      |> Enum.reduce(acc, fn {key, value}, inner_acc ->
        Map.update(inner_acc, key, value, &(&1 + value))
      end)
    end)
    |> Enum.max_by(&elem(&1, 1))
    |> elem(1)
  end

  defp next_number(secret_number) do
    [
      &(&1 <<< 6),
      &(&1 >>> 5),
      &(&1 <<< 11)
    ]
    |> Enum.reduce(secret_number, &mix_and_prune(&2, &1))
  end

  defp mix_and_prune(secret_number, mix_fn) do
    secret_number
    |> mix_fn.()
    |> bxor(secret_number)
    |> prune()
  end

  defp prune(secret_number), do: rem(secret_number, 16_777_216)
end
