defmodule Day03Test do
  use ExUnit.Case

  import Elixir.Day03
  import Test.Common

  @example_input "test/input/day03/example"
  @real_input "test/input/day03/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_lines()

    result = part1(input)

    assert 161 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_lines()

    result = part1(input)

    assert 183_788_984 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_lines()

    result = part2(input)

    assert 48 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_lines()

    result = part2(input)

    assert 62_098_619 == result
  end
end
