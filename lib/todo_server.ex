defmodule TodoServer do
  @moduledoc """
  Server

  ## Example

      iex> ts = TodoServer.start
      ...> TodoServer.add_entry(ts, %{date: {2013, 12, 19}, title: "Dentist"})
      ...> TodoServer.add_entry(ts, %{date: {2013, 12, 20}, title: "Shopping"})
      ...> TodoServer.add_entry(ts, %{date: {2013, 12, 19}, title: "Movies"})
      ...> TodoServer.entries(ts, {2013, 12, 19})
      [%{id: 1, date: {2013, 12, 19}, title: "Dentist"},
       %{id: 3, date: {2013, 12, 19}, title: "Movies"}]
  """

  @doc """
  Start a server.
  """
  def start, do: spawn(fn -> loop(Todo.new) end)

  @doc """
  Add a new entry to the to-do list.
  """
  def add_entry(todo_server, new_entry),
    do: send(todo_server, {:add_entry, new_entry})

  @doc """
  Return all entries from one date in the to-do list.
  """
  def entries(todo_server, date) do
    send(todo_server, {:entries, self, date})

    receive do
      {:todo_entries, entries} -> entries
    after 5000 ->
      {:error, :timeout}
    end
  end

  @doc """
  Update a entry in the to-do list with a update function.

  ## Example

      iex> ts = TodoServer.start
      ...> TodoServer.add_entry(ts, %{date: {2016, 06, 26}, title: "Code"})
      ...> TodoServer.update_entry(ts, 1, &Map.put(&1, :date, {2016, 06, 28}))
      ...> TodoServer.entries(ts, {2016, 06, 28})
      [%{id: 1, date: {2016, 06, 28}, title: "Code"}]
  """
  def update_entry(todo_server, entry_id, updater_fun),
    do: send(todo_server, {:update_entry, entry_id, updater_fun})

  defp loop(todo_list) do
    new_todo_list = receive do
      message ->
        process_message(todo_list, message)
    end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add_entry, new_entry}),
    do: Todo.add_entry(todo_list, new_entry)

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:todo_entries, Todo.entries(todo_list, date)})
    todo_list
  end

  defp process_message(todo_list, {:update_entry, entry_id, updater_fun}),
    do: Todo.update_entry(todo_list, entry_id, updater_fun)

  defp process_message(todo_list, _), do: todo_list
end
