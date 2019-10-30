# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Timesheets.Repo.insert!(%Timesheets.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Timesheets.Repo
alias Timesheets.Users.User

Repo.insert!(%User{name: "worker1", email: "worker1@example.com"})
Repo.insert!(%User{name: "manager1", email: "manager1@example.com"})