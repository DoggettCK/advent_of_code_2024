defmodule Day19Test do
  use ExUnit.Case

  import Elixir.Day19
  import Test.Common

  @example_input "test/input/day19/example"
  @real_input "test/input/day19/real"

  setup_all do
    Cachex.start_link(:day19_cache)

    :ok
  end

  setup do
    Cachex.reset(:day19_cache)

    :ok
  end

  # @tag :skip
  test "part1 example" do
    {patterns, designs} =
      @example_input
      |> parse_input()

    result = part1(patterns, designs)

    assert 6 == result
  end

  # @tag :skip
  test "part1 real" do
    {patterns, designs} =
      @real_input
      |> parse_input()

    result = part1(patterns, designs)

    assert 371 == result
  end

  # @tag :skip
  test "part2 example" do
    {patterns, designs} =
      @example_input
      |> parse_input()

    result = part2(patterns, designs)

    assert 16 == result
  end

  # @tag :skip
  test "part2 real" do
    {patterns, designs} =
      @real_input
      |> parse_input()

    result = part2(patterns, designs)

    assert 650_354_687_260_341 == result
  end

  defp parse_input(filename) do
    [patterns, designs] =
      filename
      |> read_file()
      |> String.split("\n\n")

    {
      patterns |> String.split(", ", trim: true),
      designs |> String.split("\n", trim: true)
    }
  end
end
