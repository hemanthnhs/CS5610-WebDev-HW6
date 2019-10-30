defmodule Timesheets.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :desc, :string
    field :hours, :float
#    field :job_id, :id
#    field :user_id, :id

    belongs_to :job, Timesheets.Jobs.Job
    belongs_to :user, Timesheets.Users.User
    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:hours, :desc, :job_id, :user_id])
    |> validate_required([:hours, :desc, :job_id, :user_id])
  end
end
