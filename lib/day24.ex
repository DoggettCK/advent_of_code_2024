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

  def part2(args) do
    operations = parse_operations(args)

    operations_map =
      operations
      |> Enum.into(%{}, &{&1.dest, Map.drop(&1, [:dest])})

    ones =
      operations
      |> Enum.filter(&xy_operation?/1)
      |> Enum.reduce(%{}, fn operation, acc ->
        %{left: left, right: right, op: op, dest: dest} = operation

        l = get_id(left)
        r = get_id(right)

        case {l, r, op} do
          {^l, ^l, "XOR"} ->
            Map.put(acc, l, dest)

          {^l, ^l, "AND"} ->
            acc
        end
      end)

    # Figured out rjm <-> wsv manually
    swaps =
      simulate([["rjm", "wsv"]], fn
        45, new_swaps ->
          return(new_swaps)

        i, new_swaps ->
          target = "z#{i |> to_string() |> String.pad_leading(2, "0")}"
          one_dest = Map.get(ones, i)

          target_op = Map.get(operations_map, target)

          if "XOR" == target_op.op do
            continue(new_swaps)
          else
            {replacement, _} =
              operations_map
              |> Enum.find(fn
                {_dest, %{left: ^one_dest, op: "XOR"}} -> true
                {_dest, %{right: ^one_dest, op: "XOR"}} -> true
                _ -> false
              end)

            continue([[target, replacement] | new_swaps])
          end
      end)

    operations_map =
      swaps
      |> Enum.reduce(operations_map, fn [a, b], acc ->
        a_val = Map.get(acc, a)
        b_val = Map.get(acc, b)

        acc
        |> Map.put(a, b_val)
        |> Map.put(b, a_val)
      end)

    swaps
    |> simulate(fn
      1, new_swaps ->
        continue(new_swaps)

      45, new_swaps ->
        return(new_swaps)

      i, new_swaps ->
        target = "z#{i |> to_string() |> String.pad_leading(2, "0")}"

        %{op: op, left: l, right: r} = Map.get(operations_map, target)

        if "XOR" == op do
          continue(new_swaps)
        else
          left_op = Map.get(operations_map, l)
          right_op = Map.get(operations_map, r)

          case {left_op, right_op} do
            {%{op: "OR"}, %{op: "XOR"}} ->
              continue(new_swaps)

            {%{op: "XOR"}, %{op: "OR"}} ->
              continue(new_swaps)

            {%{op: "OR"}, _} ->
              continue([[r, Map.get(ones, i)] | new_swaps])

            _ ->
              continue([[l, Map.get(ones, i)] | new_swaps])
          end
        end
    end)
    |> List.flatten()
    |> Enum.sort()
    |> Enum.join(",")

    # return swaps.flat().sort().join(',');
  end

  defp xy_operation?(%{left: "x" <> _, right: "y" <> _}), do: true
  defp xy_operation?(%{left: "y" <> _, right: "x" <> _}), do: true
  defp xy_operation?(_), do: false

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

  defp get_id(name) do
    ~r/^[xy]/
    |> Regex.replace(name, "")
    |> String.to_integer()
  end
end
