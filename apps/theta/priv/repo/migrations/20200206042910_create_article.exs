defmodule Theta.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:article) do
      add :title, :string
      add :summary, :string
      add :body, :text
      add :photo, :string
      add :is_serial, :boolean
      add :serial_id, references(:article, on_delete: :nothing)
      add :path_alias_id, references(:path_alias, on_delete: :delete_all), null: false
      add :author_id, references(:author, on_delete: :nothing)
      add :menu_id, references(:term, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:article, [:path_alias_id])
    create index(:article, [:author_id])
    create index(:article, [:menu_id])
  end
end
