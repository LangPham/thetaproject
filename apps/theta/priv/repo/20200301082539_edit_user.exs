defmodule Theta.Repo.Migrations.EditUser do
  use Ecto.Migration
  import Ecto.Query, warn: false

  def up do
    alter table(:user) do
      add :role, :string
    end
    flush()
    from(u in Theta.Account.User, update: [set: [role: "ROOT"]])
    |> Theta.Repo.update_all([])
  end
  def down do

  end
end
