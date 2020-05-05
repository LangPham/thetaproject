defmodule Theta.Repo.Migrations.EditUser do
  use Ecto.Migration
  import Ecto.Query, warn: false

  def up do
    alter table(:user) do
      add :avatar, :string
    end
#    flush()
#    from(u in Theta.Account.User, update: [set: [avatar: "ROOT"]])
#    |> Theta.Repo.update_all([])
  end
  def down do

  end
end
