defmodule Day07Test do
  use ExUnit.Case

  import Elixir.Day07
  import Test.Common

  @example_input "test/input/day07/example"
  @real_input "test/input/day07/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input)

    assert 3749 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input)

    assert 932_137_732_557 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_ints()

    result = part2(input)

    assert 11387 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input)

    assert 661_823_605_105_500 == result
  end
end
