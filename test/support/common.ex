defmodule Test.Common do
  def load_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def read_ints(filename) do
    filename
    |> load_input()
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
