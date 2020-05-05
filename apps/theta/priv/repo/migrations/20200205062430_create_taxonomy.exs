defmodule Theta.Repo.Migrations.CreateTaxonomy do
  use Ecto.Migration

  def change do
    create table(:taxonomy) do
      add :title, :string
      add :slug, :string

      timestamps()
    end

  end
end
