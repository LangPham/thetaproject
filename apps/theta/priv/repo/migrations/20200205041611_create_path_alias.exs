defmodule Theta.Repo.Migrations.CreatePathAlias do
  use Ecto.Migration

  def change do
    create table(:path_alias) do
      add :slug, :string
      add :type_model, :string

      timestamps()
    end

    create unique_index(:path_alias, [:slug])
  end
end
