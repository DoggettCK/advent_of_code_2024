defmodule Day24 do
  import Bitwise
  import Common

  def part1(args) do
    {parse_wires(args), parse_operations(args)}
    |> simulate(fn
      _i, {wires, []} ->
        return(wires)

      _i, {wires, operations} ->
        {new_wires, new_operations} =
          operations
          |> Enum.reduce({wires, []}, fn operation, {acc, reruns} ->
            %{op: op, dest: dest} = operation

            left = Map.get(acc, operation.left)
            right = Map.get(acc, operation.right)

            op
            |> run_instruction(left, right)
            |> case do
              nil ->
                {acc, [operation | reruns]}

              value ->
                {Map.put(acc, dest, value), reruns}
            end
          end)

        continue({new_wires, Enum.reverse(new_operations)})
    end)
    |> Map.filter(fn {k, _} -> String.starts_with?(k, "z") end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.reverse()
    |> Enum.map_join(&elem(&1, 1))
    |> Integer.parse(2)
    |> elem(0)
  end

  def part2(_args) do
  end

  defp parse_wires(args) do
    args
    |> Enum.take_while(&not_blank?/1)
    |> Enum.reduce(%{}, fn line, acc ->
      [register, value] = String.split(line, ": ")

      {value, _} = Integer.parse(value)

      Map.put(acc, register, value)
    end)
  end

  defp parse_operations(args) do
    args
    |> Enum.drop_while(&not_blank?/1)
    |> Enum.drop(1)
    |> Enum.map(fn line ->
      [left, op, right, _, dest] = String.split(line, " ")

      %{op: op, left: left, right: right, dest: dest}
    end)
  end

  defp not_blank?(""), do: false
  defp not_blank?(_), do: true

  defp run_instruction(_op, nil, _), do: nil
  defp run_instruction(_op, _, nil), do: nil
  defp run_instruction("AND", left, right), do: left &&& right
  defp run_instruction("XOR", left, right), do: bxor(left, right)
  defp run_instruction("OR", left, right), do: left ||| right
end
