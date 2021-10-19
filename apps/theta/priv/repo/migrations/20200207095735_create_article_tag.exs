defmodule Theta.Repo.Migrations.CreateArticleTags do
  use Ecto.Migration

  def change do
    create table(:article_tag, primary_key: false) do
      add(:article_id, references(:article, on_delete: :delete_all), primary_key: true)
      add(:path_alias_id, references(:path_alias, on_delete: :delete_all), primary_key: true)
      # timestamps()
    end

    create(index(:article_tag, [:article_id]))
    create(index(:article_tag, [:path_alias_id]))

    create(
      unique_index(:article_tag, [:article_id, :path_alias_id],
        name: :article_id_path_alias_id_unique_index
      )
    )
  end
end
