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
    IO.inspect(sheet.logs)
    IO.puts ("==============================================================")
    IO.inspect (attrs)
    sheet
    |> cast(attrs, [:date, :approved, :user_id])
    |> validate_required([:date, :approved, :user_id])
    |> validate_change(:date, &validate_pastdate/2)
    |> validate_hours(attrs)
  end

  def validate_hours(changeset, attrs) do
    if(map_size(attrs) == 0) do
      changeset
    else
      # https://stackoverflow.com/questions/33492121/how-to-do-reduce-with-index-in-elixir
      {_, total_hours} = 1..8
      |> Enum.reduce({1,0}, fn(num,{index,current_result}) ->
        if (attrs["job_id_#{index}"] != "") do
          {hours, _} = Integer.parse(attrs["hours_#{index}"])
          {index+1,current_result + hours}
        else
          {index+1,current_result}
        end
      end)
      if(total_hours > 0) do
        if(total_hours <= 8) do
          changeset
        else
          Ecto.Changeset.add_error(changeset, :total_hours, "Total hours exceeded 8. Please check and submit.")
        end
      else
        Ecto.Changeset.add_error(changeset, :total_hours, "Minimum of 0 hours should be logged.")
      end
    end
  end

  def validate_pastdate(_, date) do
#    Attribution for past date validation
#    https://elixirforum.com/t/ecto-fields-validations/6081
    Date.compare(date, Date.utc_today())
    |> get_error
  end

  defp get_error(comparison) when comparison == :gt, do: [ date: "Please select a date in the past" ]
  defp get_error(_), do: []

  @doc false
  def formatset(sheet) do
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
