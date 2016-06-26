defmodule Todo do
  @moduledoc """
  Simple to-do list.

  ## Example

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})
      ...> |> Todo.add_entry(%{date: {2013, 12, 20}, title: "Shopping"})
      ...> |> Todo.add_entry(%{date: {2013, 12, 19}, title: "Movies"})
      ...> |> Todo.entries({2013, 12, 19})
      [%{id: 1, date: {2013, 12, 19}, title: "Dentist"},
       %{id: 3, date: {2013, 12, 19}, title: "Movies"}]
  """

  defstruct auto_id: 1, entries: %{}

  @doc """
  Create new empty to-do list.

  ## Example

      iex> Todo.new
      %Todo{}
  """
  def new, do: %__MODULE__{}

  @doc """
  Add new entry to the date in the to-do list.

  ## Example

      iex> Todo.new |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      %Todo{
        auto_id: 2,
        entries: %{1 => %{id: 1, date: {2016, 06, 26}, title: "Code"}}
      }

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code more"})
      %Todo{
        auto_id: 3,
        entries: %{
          1 => %{id: 1, date: {2016, 06, 26}, title: "Code"},
          2 => %{id: 2, date: {2016, 06, 26}, title: "Code more"}
        }
      }
  """
  def add_entry(
    %__MODULE__{entries: entries, auto_id: auto_id} = todo_list,
    entry
  ) do
    entry = Map.put(entry, :id, auto_id) # Set id on the entry
    new_entries = Map.put(entries, auto_id, entry) # Add entry to entries

    %__MODULE__{todo_list | entries: new_entries, auto_id: auto_id + 1}
  end

  @doc """
  Get all entries for one date.

  ## Example

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.entries({2016, 06, 26})
      [%{id: 1, date: {2016, 06, 26}, title: "Code"}]

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.entries({2016, 06, 28})
      []
  """
  def entries(%__MODULE__{entries: entries}, date),
    do: entries
        |> Stream.filter(fn({_, entry}) -> entry.date == date end)
        |> Enum.map(fn({_, entry}) -> entry end)
end
