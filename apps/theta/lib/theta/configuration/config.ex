defmodule Theta.Configuration.Config do
  use Ecto.Schema
  import Ecto.Changeset

  schema "config" do
    field :key, :string
    field :value, :string
  end

  @doc false
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
