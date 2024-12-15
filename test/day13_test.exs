defmodule Day13Test do
  use ExUnit.Case

  import Elixir.Day13
  import Test.Common

  @example_input "test/input/day13/example"
  @real_input "test/input/day13/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input)

    assert 480 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input)

    assert 40069 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_ints()

    result = part2(input)

    assert 875_318_608_908 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input)

    assert 71_493_195_288_102 == result
  end
end
