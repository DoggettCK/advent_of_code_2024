defmodule Day20Test do
  use ExUnit.Case

  import Elixir.Day20
  import Test.Common

  @example_input "test/input/day20/example"
  @real_input "test/input/day20/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_grid()

    result = part1(input, 12)

    assert 8 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_grid()

    result = part1(input, 100)

    assert 1351 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_grid()

    result = part2(input, 50)

    assert 285 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_grid()

    result = part2(input, 100)

    assert 966_130 == result
  end
end
