defmodule Theta.Upload.Type do
  @moduledoc """
  This module represents a simple wrapper around ':string' Ecto type.
  """

  @behaviour Ecto.Type

  def type, do: :string

  def cast(%{filename: filename, path: path, content_type: content_type}) do
    {
      :ok,
      %{
        filename: filename,
        path: path,
        content_type: content_type
      }
    }
  end

  def cast(_), do: :error
  def load(string) when is_nil(string) do
    {:ok, string}
  end
  def load(string) when is_binary(string), do: {:ok, string}
  def load(_), do: :error

  def dump(string) when is_binary(string), do: {:ok, string}
  def dump(_), do: :error

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2

end
