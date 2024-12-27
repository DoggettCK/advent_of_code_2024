defmodule Day23Test do
  use ExUnit.Case

  import Elixir.Day23
  import Test.Common

  @example_input "test/input/day23/example"
  @real_input "test/input/day23/real"

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_lines()

    result = part1(input)

    assert 7 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_lines()

    result = part1(input)

    assert 1419 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_lines()

    result = part2(input)

    assert "co,de,ka,ta" == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_lines()

    result = part2(input)

    assert "af,aq,ck,ee,fb,it,kg,of,ol,rt,sc,vk,zh" == result
  end
end
