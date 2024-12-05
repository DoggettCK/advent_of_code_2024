defmodule Day03 do
  @mul_regex ~r/mul\((\d{1,3}),(\d{1,3})\)/
  @mul_do_regex ~r/(do\(\)|don\'t\(\)|mul\((\d{1,3}),(\d{1,3})\))/

  def part1(args) do
    args
    |> Enum.join("\n")
    |> then(&Regex.scan(@mul_regex, &1, capture: :all_but_first))
    |> Enum.reduce(0, fn operands, acc ->
      operands
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()
      |> Kernel.+(acc)
    end)
  end

  def part2(args) do
    args
    |> Enum.join("\n")
    |> then(&Regex.scan(@mul_do_regex, &1, capture: :all_but_first))
    |> Enum.reduce({:enabled, 0}, &process_instructions/2)
    |> elem(1)
  end

  defp process_instructions(["mul(" <> _ | rest], {:enabled, acc}) do
    product =
      rest
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()

    {:enabled, acc + product}
  end

  defp process_instructions(["do()"], {_, acc}) do
    {:enabled, acc}
  end

  defp process_instructions(["don't()"], {_, acc}) do
    {:disabled, acc}
  end

  defp process_instructions(_, acc), do: acc
end
