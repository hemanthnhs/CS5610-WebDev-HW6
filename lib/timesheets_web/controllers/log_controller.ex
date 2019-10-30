defmodule TimesheetsWeb.LogController do
  use TimesheetsWeb, :controller

  alias Timesheets.Jobs
  alias Timesheets.Logs
  alias Timesheets.Logs.Log

  def index(conn, _params) do
    logs = Logs.list_logs_by_logged(conn.assigns[:current_user].id)
    render(conn, "index.html", logs: logs)
  end

  def new(conn, _params) do
#    Attribution : https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    jobs = Jobs.list_jobs() |> Enum.map(&{&1.jobname, &1.id})
    changeset = Logs.change_log(%Log{})
    render(conn, "new.html", changeset: changeset, jobs: jobs)
  end

  def create(conn, %{"log" => log_params}) do
    log_params = Map.put(log_params, "user_id", conn.assigns[:current_user].id)
    case Logs.create_log(log_params) do
      {:ok, log} ->
        conn
        |> put_flash(:info, "Work Log request created successfully. Sent for Manager Approval.")
        |> redirect(to: Routes.log_path(conn, :show, log))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def requests(conn, _params) do
    logs = Logs.list_logs_by_created(conn.assigns[:current_user].id)
    render(conn, "index.html", logs: logs)
  end

  def show(conn, %{"id" => id}) do
    log = Logs.get_log!(id)
    render(conn, "show.html", log: log)
  end

  def edit(conn, %{"id" => id}) do
    log = Logs.get_log!(id)
    changeset = Logs.change_log(log)
    render(conn, "edit.html", log: log, changeset: changeset)
  end

  def update(conn, %{"id" => id, "log" => log_params}) do
    log = Logs.get_log!(id)

    case Logs.update_log(log, log_params) do
      {:ok, log} ->
        conn
        |> put_flash(:info, "Log updated successfully.")
        |> redirect(to: Routes.log_path(conn, :show, log))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", log: log, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    log = Logs.get_log!(id)
    {:ok, _log} = Logs.delete_log(log)

    conn
    |> put_flash(:info, "Log deleted successfully.")
    |> redirect(to: Routes.log_path(conn, :index))
  end
end
