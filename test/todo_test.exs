defmodule TodoTest do
  use ExUnit.Case
  doctest Todo

  test "to-do is collectable" do
    entries = [%{date: {2016, 06, 19}, title: "Dentist"},
               %{date: {2016, 06, 20}, title: "Shopping"},
               %{date: {2016, 06, 19}, title: "Movies"}]

    result = for entry <- entries, into: Todo.new, do: entry

    expected = %Todo{
      auto_id: 4,
      entries: %{
        1 => %{id: 1, date: {2016, 06, 19}, title: "Dentist"},
        2 => %{id: 2, date: {2016, 06, 20}, title: "Shopping"},
        3 => %{id: 3, date: {2016, 06, 19}, title: "Movies"}
      }
    }

    assert result == expected
  end
end
