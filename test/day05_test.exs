defmodule Day05Test do
  use ExUnit.Case

  import Elixir.Day05
  import Test.Common

  @example_input "test/input/day05/example"
  @real_input "test/input/day05/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input)

    assert 143 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input)

    assert 5268 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_ints()

    result = part2(input)

    assert 123 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input)

    assert 5799 == result
  end
end
