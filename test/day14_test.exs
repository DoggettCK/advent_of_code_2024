defmodule Day14Test do
  use ExUnit.Case

  import Elixir.Day14
  import Test.Common

  @example_input "test/input/day14/example"
  @real_input "test/input/day14/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input, {11, 7})

    assert 12 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input, {101, 103})

    assert 221_616_000 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input, {101, 103})

    assert 7572 == result
  end
end
