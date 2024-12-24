defmodule Day21Test do
  use ExUnit.Case

  import Elixir.Day21
  import Test.Common

  @example_input "test/input/day21/example"
  @real_input "test/input/day21/real"
  @cache_name :day21_cache

  setup_all do
    Cachex.start_link(@cache_name)
    :ok
  end

  setup do
    Cachex.reset(@cache_name)
    :ok
  end

  # @tag :skip
  test "part1 example" do
    input =
      @example_input
      |> read_lines()

    result = part1(input)

    assert 126_384 == result
  end

  # @tag :skip
  test "part1 real" do
    input =
      @real_input
      |> read_lines()

    result = part1(input)

    assert 163_086 == result
  end

  # @tag :skip
  test "part2 example" do
    input =
      @example_input
      |> read_lines()

    result = part2(input)

    assert 154_115_708_116_294 == result
  end

  # @tag :skip
  test "part2 real" do
    input =
      @real_input
      |> read_lines()

    result = part2(input)

    assert 198_466_286_401_228 == result
  end
end
