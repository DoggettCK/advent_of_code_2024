defmodule Day25Test do
  use ExUnit.Case

  import Elixir.Day25
  import Test.Common

  @example_input "test/input/day25/example"
  @real_input "test/input/day25/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_lines()

    result = part1(input)

    assert 3 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_lines()

    result = part1(input)

    assert 2835 == result
  end
end
