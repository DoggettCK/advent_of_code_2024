defmodule Day17 do
  import Bitwise
  import Common

  def part1(args) do
    args
    |> build_machine()
    |> run_program()
    |> Enum.join(",")
  end

  def part2(args) do
    [_, _, _, program] = args

    machine = build_machine(args)

    program
    |> tails()
    |> Enum.reverse()
    |> tl()
    |> find_quine_input(machine, 0)
    |> Enum.min()
  end

  defp find_quine_input([], _machine, answer), do: [answer]

  defp find_quine_input([target | targets], machine, answer) do
    0..7
    |> Enum.map(&((answer <<< 3) + &1))
    |> Enum.filter(fn a ->
      machine
      |> Map.put(:a, a)
      |> run_program()
      |> Kernel.==(target)
    end)
    |> Enum.flat_map(fn a ->
      find_quine_input(targets, machine, a)
    end)
  end

  defp build_machine(args) do
    [[a], [b], [c], program] = args

    %{
      a: a,
      b: b,
      c: c,
      ip: 0,
      output: [],
      program: list_to_arraymap(program),
      program_length: length(program)
    }
  end

  defp run_program(machine) do
    machine
    |> simulate(fn
      _i, %{ip: ip, program_length: len, output: output} when ip >= len ->
        return(Enum.reverse(output))

      _i, state ->
        operation = Map.get(state.program, state.ip)
        operand = Map.get(state.program, state.ip + 1)

        perform_operation(operation, operand, state)
    end)
  end

  @adv 0
  @bxl 1
  @bst 2
  @jnz 3
  @bxc 4
  @out 5
  @bdv 6
  @cdv 7

  defp perform_operation(@adv, operand, machine) do
    numerator = Map.get(machine, :a)

    denominator =
      operand
      |> combo_operand(machine)
      |> then(&(2 ** &1))

    continue(%{machine | a: div(numerator, denominator), ip: machine.ip + 2})
  end

  defp perform_operation(@bxl, operand, machine) do
    continue(%{machine | b: bxor(machine.b, operand), ip: machine.ip + 2})
  end

  defp perform_operation(@bst, operand, machine) do
    continue(%{machine | b: operand |> combo_operand(machine) |> rem(8), ip: machine.ip + 2})
  end

  defp perform_operation(@jnz, operand, machine) do
    case Map.get(machine, :a) do
      0 ->
        continue(%{machine | ip: machine.ip + 2})

      _ ->
        continue(%{machine | ip: operand})
    end
  end

  defp perform_operation(@bxc, _operand, machine) do
    continue(%{machine | b: bxor(machine.b, machine.c), ip: machine.ip + 2})
  end

  defp perform_operation(@out, operand, machine) do
    continue(%{
      machine
      | output: [operand |> combo_operand(machine) |> rem(8) | machine.output],
        ip: machine.ip + 2
    })
  end

  defp perform_operation(@bdv, operand, machine) do
    numerator = Map.get(machine, :a)

    denominator =
      operand
      |> combo_operand(machine)
      |> then(&(2 ** &1))

    continue(%{machine | b: div(numerator, denominator), ip: machine.ip + 2})
  end

  defp perform_operation(@cdv, operand, machine) do
    numerator = Map.get(machine, :a)

    denominator =
      operand
      |> combo_operand(machine)
      |> then(&(2 ** &1))

    continue(%{machine | c: div(numerator, denominator), ip: machine.ip + 2})
  end

  defp combo_operand(n, _machine) when n < 4, do: n
  defp combo_operand(4, machine), do: Map.get(machine, :a)
  defp combo_operand(5, machine), do: Map.get(machine, :b)
  defp combo_operand(6, machine), do: Map.get(machine, :c)
end
