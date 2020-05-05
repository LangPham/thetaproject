defmodule Theta.PV.PathError do
  use Ecto.Schema
  import Ecto.Changeset

  alias Theta.PV.PathAlias

  schema "path_error" do

    field :path, :string
    field :count, :integer, default: 1
    belongs_to :path_alias, PathAlias

    timestamps()
  end

  @doc false
  def changeset(path_error, attrs) do
    path_error
    |> cast(attrs, [:path, :count, :path_alias_id])
    |> validate_required([:path])
  end
end
