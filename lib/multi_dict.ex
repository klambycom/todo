defmodule MultiDict do
  @moduledoc """
  A multi dict allows multiple values to be stored under a single key and
  retrieving all values for that key.

  ## Example

      iex> MultiDict.new
      ...> |> MultiDict.add(:one, 1)
      ...> |> MultiDict.add(:two, 2)
      ...> |> MultiDict.add(:one, 3)
      ...> |> MultiDict.get(:one)
      [3, 1]
  """

  @doc """
  Create new empty multi dict.
  """
  def new, do: %{}

  @doc """
  Add new entry to the multi dict.
  """
  def add(multi_dict, key, value),
    do: Map.update(multi_dict, key, [value], &([value | &1]))

  @doc """
  Get all values from one single key or empty list if the keys have no values.
  """
  def get(multi_dict, key), do: Map.get(multi_dict, key, [])
end
