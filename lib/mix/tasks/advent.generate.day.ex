defmodule Mix.Tasks.Advent.Generate.Day do
  # https://www.youtube.com/watch?v=gpaV4bgEG-g
  use Igniter.Mix.Task

  @example "mix advent.generate.day 1"

  @shortdoc "Generate code for a numbered day of Advent of Code"
  @moduledoc """
  #{@shortdoc}

  Given a day between 1-25, generates a module, test file, and real/example
  input files.

  ## Example

  ```bash
  #{@example}
  ```
  """

  @impl Igniter.Mix.Task
  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      # Groups allow for overlapping arguments for tasks by the same author
      # See the generators guide for more.
      group: :advent_of_code_2024,
      # dependencies to add
      adds_deps: [],
      # dependencies to add and call their associated installers, if they exist
      installs: [],
      # An example invocation
      example: @example,
      # a list of positional arguments, i.e `[:file]`
      positional: [{:day, optional: true}],
      # Other tasks your task composes using `Igniter.compose_task`, passing in the CLI argv
      # This ensures your option schema includes options from nested tasks
      composes: [],
      # `OptionParser` schema
      schema: [],
      # Default values for the options in the `schema`
      defaults: [],
      # CLI aliases
      aliases: [],
      # A list of options in the schema that are required
      required: []
    }
  end

  @impl Igniter.Mix.Task
  def igniter(igniter, argv) do
    # Do your work here and return an updated igniter
    {arguments, _argv} = positional_args!(argv)

    day =
      arguments
      |> Map.get(:day)
      |> advent_day()
      |> to_string()
      |> String.pad_leading(2, "0")

    day_module_name = Igniter.Project.Module.parse("Day#{day}")
    test_module_name = Igniter.Project.Module.parse("Day#{day}Test")
    example_input_file = "test/input/day#{day}/example"
    real_input_file = "test/input/day#{day}/real"

    igniter
    |> Igniter.create_new_file(example_input_file, "\n")
    |> Igniter.create_new_file(real_input_file, "\n")
    |> Igniter.Project.Module.create_module(day_module_name, """
      import Common

      def part1(_args) do

      end

      def part2(_args) do

      end
    """)
    |> Igniter.Project.Module.create_module(
      test_module_name,
      """
      use ExUnit.Case

      import #{day_module_name}
      import Test.Common

      @example_input "#{example_input_file}"
      @real_input "#{real_input_file}"

      @tag :skip
      test "part1 example" do
        input = @example_input
                |> read_lines()
        result = part1(input)

        assert 0 == result
      end

      @tag :skip
      test "part1 real" do
        input = @real_input
                |> read_lines()
        result = part1(input)

        assert 0 == result
      end

      @tag :skip
      test "part2 example" do
        input = @example_input
                |> read_lines()
        result = part2(input)

        assert 0 == result
      end

      @tag :skip
      test "part2 real" do
        input = @real_input
                |> read_lines()
        result = part2(input)

        assert 0 == result
      end
      """,
      location: :test
    )
  end

  defp advent_day(day) when is_binary(day) do
    case Integer.parse(day) do
      {day, _} when day in 1..25 ->
        day

      _ ->
        raise ArgumentError, "provide a valid day number from 1-25"
    end
  end
end
