defmodule Theta.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string
      add :username, :string
      add :role, :string
      timestamps()
    end

    create unique_index(:user, [:username])
  end
end
