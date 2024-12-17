defmodule Day15Test do
  use ExUnit.Case

  import Elixir.Day15
  import Test.Common

  @example_input "test/input/day15/example"
  @real_input "test/input/day15/real"

  # @tag :skip
  test "part1 example" do
    {grid, dirs} =
      @example_input
      |> parse_input()

    result = part1(grid, dirs)

    assert 10092 == result
  end

  # @tag :skip
  test "part1 real" do
    {grid, dirs} =
      @real_input
      |> parse_input()

    result = part1(grid, dirs)

    assert 1_383_666 == result
  end

  @tag :skip
  test "part2 example" do
    {grid, dirs} =
      @example_input
      |> parse_input()

    result = part2(grid, dirs)

    assert 0 == result
  end

  @tag :skip
  test "part2 real" do
    {grid, dirs} =
      @real_input
      |> parse_input()

    result = part2(grid, dirs)

    assert 0 == result
  end

  defp parse_input(filename) do
    [grid_lines, directions] =
      filename
      |> read_file()
      |> String.split("\n\n")

    {
      read_grid_from_string(grid_lines),
      directions
      |> String.replace("\n", "")
      |> String.graphemes()
    }
  end
end
