defmodule Day06Test do
  use ExUnit.Case

  import Elixir.Day06
  import Test.Common

  @example_input "test/input/day06/example"
  @real_input "test/input/day06/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_grid()

    result = part1(input)

    assert 41 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_grid()

    result = part1(input)

    assert 4559 == result
  end

  @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_grid()

    result = part2(input)

    assert 0 == result
  end

  @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_grid()

    result = part2(input)

    assert 0 == result
  end
end
