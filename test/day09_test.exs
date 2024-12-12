defmodule Day09Test do
  use ExUnit.Case

  import Elixir.Day09
  import Test.Common

  @example_input "test/input/day09/example"
  @real_input "test/input/day09/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_file()

    result = part1(input)

    assert 1928 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_file()

    result = part1(input)

    assert 6_340_197_768_906 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_file()

    result = part2(input)

    assert 2858 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_file()

    result = part2(input)

    assert 6_363_913_128_533 == result
  end
end
