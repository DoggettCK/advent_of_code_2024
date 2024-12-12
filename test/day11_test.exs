defmodule Day11Test do
  use ExUnit.Case

  import Elixir.Day11
  import Test.Common

  @example_input "test/input/day11/example"
  @real_input "test/input/day11/real"

  setup_all do
    Cachex.start_link(:day11_cache)
    :ok
  end

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_int_line()

    result = part1(input)

    assert 55312 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_int_line()

    result = part1(input)

    assert 199_753 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_int_line()

    result = part2(input)

    assert 65_601_038_650_482 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_int_line()

    result = part2(input)

    assert 239_413_123_020_116 == result
  end
end
