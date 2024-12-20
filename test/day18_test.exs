defmodule Day18Test do
  use ExUnit.Case

  import Elixir.Day18
  import Test.Common

  @example_input "test/input/day18/example"
  @real_input "test/input/day18/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input, 6, 12)

    assert 22 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input, 70, 1024)

    assert 372 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_ints()

    result = part2(input, 6)

    assert "6,1" == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input, 70)

    assert "25,6" == result
  end
end
