defmodule Timesheets.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string, null: false
    field :name, :string, null: false
    field :password_hash, :string
    field :is_manager, :boolean
    field :supervisor_id, :id , foreign_key: :user_id
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :jobs, Timesheets.Jobs.Job
    has_many :logs, Timesheets.Logs.Log
    timestamps()
  end

end
