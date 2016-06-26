defmodule Todo do
  @moduledoc """
  Simple to-do list.

  ## Example

      iex> Todo.new
      ...> |> Todo.add_entry({2013, 12, 19}, "Dentist")
      ...> |> Todo.add_entry({2013, 12, 20}, "Shopping")
      ...> |> Todo.add_entry({2013, 12, 19}, "Movies")
      ...> |> Todo.entries({2013, 12, 19})
      ["Movies", "Dentist"]
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

      iex> Todo.new |> Todo.add_entry({2016, 06, 26}, "Code")
      %{{2016, 06, 26} => ["Code"]}

      iex> Todo.new
      ...> |> Todo.add_entry({2016, 06, 26}, "Code")
      ...> |> Todo.add_entry({2016, 06, 26}, "Code more")
      %{{2016, 06, 26} => ["Code more", "Code"]}
  """
  def add_entry(todo_list, date, title),
    do: MultiDict.add(todo_list, date, title)

  @doc """
  Get all entries for one date.

  ## Example

      iex> Todo.new
      ...> |> Todo.add_entry({2016, 06, 26}, "Code")
      ...> |> Todo.entries({2016, 06, 26})
      ["Code"]

      iex> Todo.new
      ...> |> Todo.add_entry({2016, 06, 26}, "Code")
      ...> |> Todo.entries({2016, 06, 28})
      []
  """
  def entries(todo_list, date), do: MultiDict.get(todo_list, date)
end
