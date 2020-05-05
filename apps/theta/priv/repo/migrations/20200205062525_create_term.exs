defmodule Theta.Repo.Migrations.CreateTerm do
  use Ecto.Migration

  def change do
    create table(:term) do
      add :title, :string
      add :taxonomy_id, references(:taxonomy, on_delete: :delete_all), null: false
      add :path_alias_id, references(:path_alias, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:term, [:taxonomy_id])
    create unique_index(:term, [:path_alias_id])
  end
end
