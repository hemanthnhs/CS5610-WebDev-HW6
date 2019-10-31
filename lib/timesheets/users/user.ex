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
#    belongs_to :user, Timesheets.Users.User
#    has_one :supervisor_id, Timesheets.Users.User
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :password_confirmation, :is_manager])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 8) # too short
    |> hash_password()
    |> validate_required([:email, :name, :password_hash])
  end

  def hash_password(cset) do
    pw = get_change(cset, :password)
    if pw do
      change(cset, Argon2.add_hash(pw))
    else
      cset
    end
  end
end
