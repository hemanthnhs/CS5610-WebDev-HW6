defmodule Timesheets.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :serial, primary_key: true
      add :email, :string, null: false
      add :name, :string, null: false
      add :password_hash, :string, default: "", null: false
      add :is_manager, :boolean, default: false, null: false
      timestamps()
    end

  end
end
