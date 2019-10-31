defmodule Timesheets.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :desc, :string
    field :jobname, :string

    belongs_to :user, Timesheets.Users.User
    has_many :logs, Timesheets.Logs.Log
    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:jobname, :desc, :user_id])
    |> validate_required([:jobname, :desc, :user_id])
  end
end
