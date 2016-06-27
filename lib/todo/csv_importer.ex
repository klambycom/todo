defmodule Todo.CsvImporter do
  @moduledoc """
  Import to-do list from CSV-file.

  ## Example

      iex> Todo.CsvImporter.import("test/todos.csv")
      ...> |> Todo.entries({2013, 12, 19})
      [%{id: 1, date: {2013, 12, 19}, title: "Dentist"},
       %{id: 3, date: {2013, 12, 19}, title: "Movies"}]
  """

  import String, only: [to_integer: 1]

  @doc """
  Import to-do list from file path to a CSV-file.

  ## Supported formats

      2013/12/19,Dentist
      20131220,Shopping
      2013-12-19,Movies
      131221,Food
  """
  def import(file_path),
    do: File.stream!(file_path)
        |> Stream.map(&String.replace(&1, "\n", ""))
        |> Stream.map(&parse_row/1)
        |> Todo.new

  defp parse_row(<<date::bytes-size(10)>> <> "," <> title),
    do: %{date: parse_date(date), title: title}

  defp parse_row(<<date::bytes-size(8)>> <> "," <> title),
    do: %{date: parse_date(date), title: title}

  defp parse_row(<<date::bytes-size(6)>> <> "," <> title),
    do: %{date: parse_date(date), title: title}

  # 2013/12/19, 2013-12-19
  defp parse_date(
    <<year::bytes-size(4)>> <> <<separator::bytes-size(1)>> <>
    <<month::bytes-size(2)>> <> <<separator::bytes-size(1)>> <>
    <<day::bytes-size(2)>>
  ), do: {to_integer(year), to_integer(month), to_integer(day)}

  # 20131219
  defp parse_date(
    <<year::bytes-size(4)>> <> <<month::bytes-size(2)>> <> <<day::bytes-size(2)>>
  ), do: {to_integer(year), to_integer(month), to_integer(day)}

  # 131219
  defp parse_date(
    <<year::bytes-size(2)>> <> <<month::bytes-size(2)>> <> <<day::bytes-size(2)>>
  ), do: {to_integer("20#{year}"), to_integer(month), to_integer(day)}
end
