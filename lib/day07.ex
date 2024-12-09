defmodule Day07 do
  def part1(args) do
    ops = [
      fn a, b -> a + b end,
      fn a, b -> a * b end
    ]

    args
    |> Enum.map(&{has_solution?(&1, ops), &1})
    |> Enum.filter(fn {has_solution, _total} -> has_solution end)
    |> Enum.map(fn {_total, [total | _]} -> total end)
    |> Enum.sum()
  end

  def part2(args) do
    ops = [
      fn a, b -> a + b end,
      fn a, b -> a * b end,
      fn a, b -> String.to_integer("#{a}#{b}") end
    ]

    args
    |> Enum.map(&{has_solution?(&1, ops), &1})
    |> Enum.filter(fn {has_solution, _total} -> has_solution end)
    |> Enum.map(fn {_total, [total | _]} -> total end)
    |> Enum.sum()
  end

  defp has_solution?([total | operands], ops) do
    has_solution?(total, 0, operands, ops)
  end

  defp has_solution?(total, total, [], _ops), do: true
  defp has_solution?(_total, _acc, [], _ops), do: false
  defp has_solution?(total, acc, _operands, _ops) when acc > total, do: false

  defp has_solution?(total, acc, [curr | operands], ops) do
    ops
    |> Enum.any?(fn func ->
      has_solution?(total, func.(acc, curr), operands, ops)
    end)
  end
end
