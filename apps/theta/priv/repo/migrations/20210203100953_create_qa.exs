defmodule Theta.Repo.Migrations.CreateQa do
  use Ecto.Migration

  def change do
    create table(:qa) do
      add :question, :string
      add :answer, :text
      add :tag, :string

      timestamps()
    end
  end
end
