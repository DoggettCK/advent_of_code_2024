defmodule Day02Test do
  use ExUnit.Case

  import Elixir.Day02
  import Test.Common

  @example_input "test/input/day02/example"
  @real_input "test/input/day02/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input)

    assert result == 2
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input)

    assert result == 299
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_ints()

    result = part2(input)

    assert result == 2
  end

  @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input)

    assert result
  end
end
