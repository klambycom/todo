defmodule Todo do
  @moduledoc """
  Simple to-do list.

  ## Example

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})
      ...> |> Todo.add_entry(%{date: {2013, 12, 20}, title: "Shopping"})
      ...> |> Todo.add_entry(%{date: {2013, 12, 19}, title: "Movies"})
      ...> |> Todo.entries({2013, 12, 19})
      [%{date: {2013, 12, 19}, title: "Movies"},
      %{date: {2013, 12, 19}, title: "Dentist"}]
  """

  @doc """
  Create new empty to-do list.

  ## Example

      iex> Todo.new
      %{}
  """
  def new, do: MultiDict.new

  @doc """
  Add new entry to the date in the to-do list.

  ## Example

      iex> Todo.new |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      %{{2016, 06, 26} => [%{date: {2016, 06, 26}, title: "Code"}]}

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code more"})
      %{{2016, 06, 26} => [
        %{date: {2016, 06, 26}, title: "Code more"},
        %{date: {2016, 06, 26}, title: "Code"}
      ]}
  """
  def add_entry(todo_list, entry),
    do: MultiDict.add(todo_list, entry.date, entry)

  @doc """
  Get all entries for one date.

  ## Example

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.entries({2016, 06, 26})
      [%{date: {2016, 06, 26}, title: "Code"}]

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.entries({2016, 06, 28})
      []
  """
  def entries(todo_list, date), do: MultiDict.get(todo_list, date)
end
