defmodule Timesheets.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :hours, :float, null: false
      add :desc, :text
      add :job_id, references(:jobs, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :approved, :boolean, default: false, null: false

      timestamps()
    end

    create index(:logs, [:job_id])
    create index(:logs, [:user_id])
  end
end
