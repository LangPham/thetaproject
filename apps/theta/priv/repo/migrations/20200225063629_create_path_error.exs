defmodule Theta.Repo.Migrations.CreatePathError do
  use Ecto.Migration

  def change do
    create table(:path_error) do
      add :path, :string
      add :count, :bigint
      add :path_alias_id, references(:path_alias, on_delete: :nothing)

      timestamps()
    end
  end
end
