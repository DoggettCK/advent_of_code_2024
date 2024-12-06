defmodule Day04Test do
  use ExUnit.Case

  import Elixir.Day04
  import Test.Common

  @example_input "test/input/day04/example"
  @real_input "test/input/day04/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_grid()

    result = part1(input)

    assert 18 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_grid()

    result = part1(input)

    assert 2562 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_grid()

    result = part2(input)

    assert 9 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_grid()

    result = part2(input)

    assert 1902 == result
  end
end
