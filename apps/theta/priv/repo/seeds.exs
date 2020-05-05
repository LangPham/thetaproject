# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Theta.Repo.insert!(%Theta.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Theta.Repo.insert!(%Theta.Account.User{name: "Root", username: "root", role: "ROOT"})
Theta.Repo.insert!(%Theta.Account.Credential{email: "root@theta.vn", password: "$2b$12$obs6kfFs4tRfBp825d3dpuUNvKtxRmohzTfo/K1EOBfG87Hky1zXu", user_id: 1})
Theta.Repo.insert!(%Theta.CMS.Taxonomy{title: "Main menu", slug: "main_menu"})
