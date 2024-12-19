defmodule Day17Test do
  use ExUnit.Case

  import Elixir.Day17
  import Test.Common

  @example_input "test/input/day17/example"
  @example2_input "test/input/day17/example2"
  @real_input "test/input/day17/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_ints()

    result = part1(input)

    assert "4,6,3,5,6,3,5,2,1,0" == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_ints()

    result = part1(input)

    assert "7,0,7,3,4,1,3,0,1" == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example2_input
      |> read_ints()

    result = part2(input)

    assert 117_440 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_ints()

    result = part2(input)

    assert 156_985_331_222_018 == result
  end
end
