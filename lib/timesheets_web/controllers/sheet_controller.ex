defmodule TimesheetsWeb.SheetController do
  use TimesheetsWeb, :controller

  alias Timesheets.Jobs
  alias Timesheets.Sheets
  alias Timesheets.Sheets.Sheet
  alias Timesheets.Logs

  def index(conn, _params) do
    sheets = Sheets.list_sheets_of_logged(conn.assigns[:current_user].id)
    render(conn, "index.html", sheets: sheets)
  end

  def new(conn, _params) do
    # Attribution : https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    jobs = Jobs.list_jobs() |> Enum.map(&{&1.jobname, &1.id})
    changeset = Sheets.change_sheet(%Sheet{})
    render(conn, "new.html", changeset: changeset, jobs: jobs)
  end

  def create(conn, %{"sheet" => sheet_params}) do
    sheet_params = Map.put(sheet_params, "user_id", conn.assigns[:current_user].id)
    case Sheets.create_sheet(sheet_params) do
      {:ok, sheet} ->
        conn
        |> put_flash(:info, "Sheet submitted for Managers Approval.")
        |> redirect(to: Routes.sheet_path(conn, :show, sheet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def dashboard(conn, _params) do
    sheets = Sheets.list_subordinate_sheets(conn.assigns[:current_user].id)
    render(conn, "index.html", sheets: sheets)
  end

  def approve(conn, %{"id" => id}) do
    IO.puts("===========================================")
    sheet = Sheets.get_sheet!(id)
    Sheets.approve_sheet(sheet)
    redirect(conn, to: Routes.sheet_path(conn, :dashboard))
  end

  def show(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    logs = Logs.get_logs(id)
    render(conn, "show.html", sheet: sheet, logs: logs)
  end

  def edit(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    changeset = Sheets.change_sheet(sheet)
    render(conn, "edit.html", sheet: sheet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sheet" => sheet_params}) do
    sheet = Sheets.get_sheet!(id)

    case Sheets.update_sheet(sheet, sheet_params) do
      {:ok, sheet} ->
        conn
        |> put_flash(:info, "Sheet updated successfully.")
        |> redirect(to: Routes.sheet_path(conn, :show, sheet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sheet: sheet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    {:ok, _sheet} = Sheets.delete_sheet(sheet)

    conn
    |> put_flash(:info, "Sheet deleted successfully.")
    |> redirect(to: Routes.sheet_path(conn, :index))
  end
end
