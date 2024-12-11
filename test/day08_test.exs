defmodule Day08Test do
  use ExUnit.Case

  import Elixir.Day08
  import Test.Common

  @example_input "test/input/day08/example"
  @real_input "test/input/day08/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_grid()

    result = part1(input)

    assert 14 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_grid()

    result = part1(input)

    assert 308 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_grid()

    result = part2(input)

    assert 34 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_grid()

    result = part2(input)

    assert 1147 == result
  end
end
