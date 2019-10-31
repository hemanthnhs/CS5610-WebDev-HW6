defmodule Timesheets.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Timesheets.Repo

  alias Timesheets.Logs.Log
  alias Timesheets.Jobs.Job
  @doc """
  Returns the list of logs.

  ## Examples

      iex> list_logs()
      [%Log{}, ...]

  """
  def list_logs do
    Repo.all(Log)
  end

  def list_logs_by_created(manager_id) do
    jobs = Repo.all(from(j in Job, select: j.id, where: j.user_id == ^manager_id))
    Repo.all(from(l in Log, where: l.job_id in ^jobs,preload: [:user, :job]))
  end

  def list_logs_by_logged(worker_id) do
#    Attribution and Reference from https://elixirforum.com/t/what-is-the-correct-way-to-use-ecto-query-that-allow-items-to-be-displayed-in-templates/7313
#    Attribution and Reference from https://elixirforum.com/t/nested-preload-from-the-doc-makes-me-confused/11991/5
    Repo.all(from(l in Log, where: l.user_id == ^worker_id, preload: [:job, job: :user]))
  end
  @doc """
  Gets a single log.

  Raises `Ecto.NoResultsError` if the Log does not exist.

  ## Examples

      iex> get_log!(123)
      %Log{}

      iex> get_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_log!(id), do: Repo.get!(Log, id)

  @doc """
  Creates a log.

  ## Examples

      iex> create_log(%{field: value})
      {:ok, %Log{}}

      iex> create_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_log(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a log.

  ## Examples

      iex> update_log(log, %{field: new_value})
      {:ok, %Log{}}

      iex> update_log(log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_log(%Log{} = log, attrs) do
    log
    |> Log.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Log.

  ## Examples

      iex> delete_log(log)
      {:ok, %Log{}}

      iex> delete_log(log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_log(%Log{} = log) do
    Repo.delete(log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking log changes.

  ## Examples

      iex> change_log(log)
      %Ecto.Changeset{source: %Log{}}

  """
  def change_log(%Log{} = log) do
    Log.changeset(log, %{})
  end
end
