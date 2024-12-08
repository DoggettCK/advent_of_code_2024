defmodule Day05 do
  import Common

  def part1(args) do
    {rules, updates} =
      Enum.split_while(args, &(length(&1) == 2))

    # |> IO.inspect(limit: :infinity, charlists: :as_lists)

    dependencies =
      Enum.group_by(rules, fn [_, obj] -> obj end, fn [depends_on, _] -> depends_on end)

    updates
    |> Enum.map(fn update ->
      # cyclical dependencies in real rules unless you limit them to pages in update
      sorted_deps =
        dependencies
        |> Map.take(update)
        |> topological_sort()

      if is_sorted_sublist?(update, sorted_deps) do
        middle_element(update)
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def part2(args) do
    {rules, updates} =
      Enum.split_while(args, &(length(&1) == 2))

    dependencies =
      Enum.group_by(rules, fn [_, obj] -> obj end, fn [depends_on, _] -> depends_on end)

    updates
    |> Enum.map(fn update ->
      # cyclical dependencies in real rules unless you limit them to pages in update
      sorted_deps =
        dependencies
        |> Map.take(update)
        |> topological_sort()

      if is_sorted_sublist?(update, sorted_deps) do
        0
      else
        # Order correctly, then take middle element
        update
        |> reorder_pages(sorted_deps)
        |> middle_element()
      end
    end)
    |> Enum.sum()
  end

  defp is_sorted_sublist?([], []), do: true
  defp is_sorted_sublist?(_, []), do: false

  defp is_sorted_sublist?([page | pages], [page | ordering]) do
    is_sorted_sublist?(pages, ordering)
  end

  defp is_sorted_sublist?([page | pages], [_ | ordering]) do
    is_sorted_sublist?([page | pages], ordering)
  end

  defp middle_element(list) do
    list
    |> length()
    |> div(2)
    |> then(&Enum.at(list, &1))
  end

  defp reorder_pages(pages, ordering) do
    page_map = Enum.into(pages, %{}, &{&1, &1})

    ordering
    |> Enum.map(&Map.get(page_map, &1))
    |> Enum.reject(&is_nil/1)
  end
end
