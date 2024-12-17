defmodule Day16Test do
  use ExUnit.Case

  import Elixir.Day16
  import Test.Common

  @example_input "test/input/day16/example"
  @real_input "test/input/day16/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_grid()

    result = part1(input)

    assert 7036 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_grid()

    result = part1(input)

    assert 85420 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_grid()

    result = part2(input)

    assert 45 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_grid()

    result = part2(input)

    assert 492 == result
  end
end
