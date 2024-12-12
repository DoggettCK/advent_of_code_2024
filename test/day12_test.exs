defmodule Day12Test do
  use ExUnit.Case

  import Elixir.Day12
  import Test.Common

  @example_input "test/input/day12/example"
  @real_input "test/input/day12/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_grid()

    result = part1(input)

    assert 1930 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_grid()

    result = part1(input)

    assert 1_363_682 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_grid()

    result = part2(input)

    assert 1206 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_grid()

    result = part2(input)

    assert 787_680 == result
  end
end
