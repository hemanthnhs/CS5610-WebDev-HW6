defmodule Timesheets.Sheets.Sheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sheets" do
    field :approved, :boolean, default: false
    field :date, :date

    belongs_to :user, Timesheets.Users.User
    has_many :logs, Timesheets.Logs.Log
    timestamps()
  end

  @doc false
  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, [:date, :approved, :user_id])
    |> validate_required([:date, :approved, :user_id])
  end

  @doc false
  def formatset(sheet) do
    IO.inspect sheet.logs
#    https://stackoverflow.com/questions/33492121/how-to-do-reduce-with-index-in-elixir
    sheet = sheet.logs
      |> Enum.with_index
      |> Enum.reduce(sheet, fn({l,index}, acc) ->
      acc = Map.put(acc, String.to_atom("job_id_#{index+1}"), l.job_id)
      acc = Map.put(acc, String.to_atom("hours_#{index+1}"), l.hours)
      Map.put(acc, String.to_atom("desc_#{index+1}"), l.desc)
    end)
    sheet = sheet
    |> cast(%{}, [:date, :approved, :user_id])
    |> validate_required([:date, :approved, :user_id])
    sheet
  end
end
