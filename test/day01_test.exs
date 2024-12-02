defmodule Day01Test do
  use ExUnit.Case

  import Elixir.Day01
  import Test.Common

  @example_input "test/input/day01/example"
  @real_input "test/input/day01/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input)

    assert result == 11
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input)

    assert result == 1_341_714
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_ints()

    result = part2(input)

    assert result == 31
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input)

    assert result == 27_384_707
  end
end
