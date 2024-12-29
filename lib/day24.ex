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
    operations =
      args
      |> parse_operations()
      |> Enum.into(%{}, &{&1.dest, Map.drop(&1, [:dest])})

    {operations, []}
    |> simulate(fn
      4, {_, swaps} ->
        return(swaps)

      _i, {ops, swaps} ->
        baseline = progress(ops)

        xs = ys = Map.keys(ops)

        case check_progress(xs, ys, baseline, ops) do
          nil ->
            return(swaps)

          {swapped_ops, x, y} ->
            continue({swapped_ops, [x, y | swaps]})
        end
    end)
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp check_progress([_x | xs], [], baseline, operations) do
    check_progress(xs, Map.keys(operations), baseline, operations)
  end

  defp check_progress([x | xs], [x | ys], baseline, operations) do
    check_progress([x | xs], ys, baseline, operations)
  end

  defp check_progress([], [], _baseline, _operations), do: nil

  defp check_progress([x | xs], [y | ys], baseline, operations) do
    swapped_ops = swap_map(operations, x, y)

    if progress(swapped_ops) > baseline do
      {swapped_ops, x, y}
    else
      check_progress([x | xs], ys, baseline, operations)
    end
  end

  defp make_wire(char, num), do: "#{char}#{num |> to_string() |> String.pad_leading(2, "0")}"

  defp verify_z(wire, _num, operations) when not is_map_key(operations, wire), do: false

  defp verify_z(wire, num, operations) do
    %{op: op, left: left, right: right} = Map.get(operations, wire)

    case {op, num} do
      {"XOR", 0} ->
        [left, right]
        |> Enum.sort()
        |> Kernel.==(["x00", "y00"])

      {"XOR", _} ->
        (verify_intermediate_xor(left, num, operations) and
           verify_carry_bit(right, num, operations)) or
          (verify_intermediate_xor(right, num, operations) and
             verify_carry_bit(left, num, operations))

      _ ->
        false
    end
  end

  defp verify_intermediate_xor(wire, _num, operations) when not is_map_key(operations, wire),
    do: false

  defp verify_intermediate_xor(wire, num, operations) do
    %{op: op, left: left, right: right} = Map.get(operations, wire)

    case op do
      "XOR" ->
        [left, right]
        |> Enum.sort()
        |> Kernel.==([
          make_wire("x", num),
          make_wire("y", num)
        ])

      _ ->
        false
    end
  end

  defp verify_carry_bit(wire, _num, operations) when not is_map_key(operations, wire), do: false

  defp verify_carry_bit(wire, num, operations) do
    %{op: op, left: left, right: right} = Map.get(operations, wire)

    case {op, num} do
      {"AND", 1} ->
        [left, right]
        |> Enum.sort()
        |> Kernel.==(["x00", "y00"])

      {_, 1} ->
        false

      {"OR", _} ->
        (verify_direct_carry(left, num - 1, operations) and
           verify_recarry(right, num - 1, operations)) or
          (verify_direct_carry(right, num - 1, operations) and
             verify_recarry(left, num - 1, operations))

      _ ->
        false
    end
  end

  defp verify_direct_carry(wire, _num, operations) when not is_map_key(operations, wire),
    do: false

  defp verify_direct_carry(wire, num, operations) do
    %{op: op, left: left, right: right} = Map.get(operations, wire)

    case op do
      "AND" ->
        [left, right]
        |> Enum.sort()
        |> Kernel.==([
          make_wire("x", num),
          make_wire("y", num)
        ])

      _ ->
        false
    end
  end

  defp verify_recarry(wire, _num, operations) when not is_map_key(operations, wire), do: false

  defp verify_recarry(wire, num, operations) do
    %{op: op, left: left, right: right} = Map.get(operations, wire)

    case op do
      "AND" ->
        (verify_intermediate_xor(left, num, operations) and
           verify_carry_bit(right, num, operations)) or
          (verify_intermediate_xor(right, num, operations) and
             verify_carry_bit(left, num, operations))

      _ ->
        false
    end
  end

  defp verify(num, operations) do
    "z"
    |> make_wire(num)
    |> verify_z(num, operations)
  end

  defp progress(operations) do
    simulate(nil, fn i, nil ->
      if verify(i, operations) do
        continue(nil)
      else
        return(i)
      end
    end)
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
