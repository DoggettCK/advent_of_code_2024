defmodule Day22Test do
  use ExUnit.Case

  import Elixir.Day22
  import Test.Common

  @example_input "test/input/day22/example"
  @example2_input "test/input/day22/example2"
  @real_input "test/input/day22/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input)

    assert 37_327_623 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input)

    assert 18_525_593_556 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example2_input
      |> read_ints()

    result = part2(input)

    assert 23 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input)

    assert 2089 == result
  end
end
