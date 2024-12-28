defmodule Day24Test do
  use ExUnit.Case

  import Elixir.Day24
  import Test.Common

  @example_input "test/input/day24/example"
  @example_input_large "test/input/day24/example_large"
  @real_input "test/input/day24/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_lines(trim: false)

    result = part1(input)

    assert 4 == result
  end

  # @tag :skip
  test "part1 larger example" do
    input =
      @example_input_large
      |> read_lines(trim: false)

    result = part1(input)

    assert 2024 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_lines(trim: false)

    result = part1(input)

    assert 65_740_327_379_952 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_lines(trim: false)

    result = part2(input)

    assert "bgs,pqc,rjm,swt,wsv,z07,z13,z31" == result
  end
end
