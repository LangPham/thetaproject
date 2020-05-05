defmodule Theta.Repo.Migrations.CreateAuthor do
  use Ecto.Migration

  def change do
    create table(:author) do
      add :role, :string
      add :user_id, references(:user, on_delete: :delete_all),
          null: false

      timestamps()
    end

    create unique_index(:author, [:user_id])
  end
end
