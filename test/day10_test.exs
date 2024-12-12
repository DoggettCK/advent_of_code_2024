defmodule Day10Test do
  use ExUnit.Case

  import Elixir.Day10
  import Test.Common

  @example_input "test/input/day10/example"
  @real_input "test/input/day10/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_int_grid()

    result = part1(input)

    assert 36 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_int_grid()

    result = part1(input)

    assert 644 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_int_grid()

    result = part2(input)

    assert 81 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_int_grid()

    result = part2(input)

    assert 1366 == result
  end
end
