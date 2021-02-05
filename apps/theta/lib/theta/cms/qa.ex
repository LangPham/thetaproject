defmodule Theta.CMS.Qa do
  use Ecto.Schema
  import Ecto.Changeset

  schema "qa" do
    field :answer, :string
    field :question, :string
    field :tag, :string

    timestamps()
  end

  @doc false
  def changeset(qa, attrs) do
    qa
    |> cast(attrs, [:question, :answer, :tag])
    |> validate_required([:question, :answer, :tag])
  end
end
