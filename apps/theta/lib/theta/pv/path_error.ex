defmodule Theta.PV.PathError do
  use Ecto.Schema
  import Ecto.Changeset



  schema "path_error" do
    field :path, :string
    field :count, :integer, default: 1
    field :redirect, :string
    timestamps()
  end

  @doc false
  def changeset(path_error, attrs) do
    path_error
    |> cast(attrs, [:path, :count, :redirect])
    |> validate_required([:path])
  end
end
