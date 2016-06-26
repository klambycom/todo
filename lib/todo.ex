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

  @doc """
  Update a entry in the to-do list with a update function, but raises a
  exception if the id of the entry is changed.

  ## Example

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.update_entry(1, &Map.put(&1, :date, {2016, 06, 28}))
      %Todo{
        auto_id: 2,
        entries: %{1 => %{id: 1, date: {2016, 06, 28}, title: "Code"}}
      }

  It does nothing if the entry do not exists.

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.update_entry(2, &Map.put(&1, :date, {2016, 06, 28}))
      %Todo{
        auto_id: 2,
        entries: %{1 => %{id: 1, date: {2016, 06, 26}, title: "Code"}}
      }
  """
  def update_entry(
    %__MODULE__{entries: entries} = todo_list,
    entry_id,
    updater_fun
  ) do
    case entries[entry_id] do
      nil -> todo_list

      old_entry ->
        old_entry_id = old_entry.id # Make sure the id hasn't been changed
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %__MODULE__{todo_list | entries: new_entries}
    end
  end

  @doc """
  Update a entry in the to-do list.

  ## Example

      iex> Todo.new
      ...> |> Todo.add_entry(%{date: {2016, 06, 26}, title: "Code"})
      ...> |> Todo.update_entry(%{id: 1, date: {2016, 06, 28}, title: "Kod"})
      %Todo{
        auto_id: 2,
        entries: %{1 => %{id: 1, date: {2016, 06, 28}, title: "Kod"}}
      }
  """
  def update_entry(todo_list, %{} = new_entry),
    do: update_entry(todo_list, new_entry.id, fn(_) -> new_entry end)
end
