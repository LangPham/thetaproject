defmodule ThetaWeb.CMS.QaController do
  use ThetaWeb, :controller

  alias Theta.CMS
  alias Theta.CMS.Qa

  def index(conn, _params) do
    qa = CMS.list_qa()
    render(conn, "index.html", qa: qa)
  end

  def new(conn, _params) do
    changeset = CMS.change_qa(%Qa{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"qa" => qa_params}) do
    case CMS.create_qa(qa_params) do
      {:ok, qa} ->
        conn
        |> put_flash(:info, "Qa created successfully.")
        |> redirect(to: Routes.qa_path(conn, :show, qa))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    qa = CMS.get_qa!(id)
    render(conn, "show.html", qa: qa)
  end

  def edit(conn, %{"id" => id}) do
    qa = CMS.get_qa!(id)
    changeset = CMS.change_qa(qa)
    render(conn, "edit.html", qa: qa, changeset: changeset)
  end

  def update(conn, %{"id" => id, "qa" => qa_params}) do
    qa = CMS.get_qa!(id)

    case CMS.update_qa(qa, qa_params) do
      {:ok, qa} ->
        conn
        |> put_flash(:info, "Qa updated successfully.")
        |> redirect(to: Routes.qa_path(conn, :show, qa))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", qa: qa, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    qa = CMS.get_qa!(id)
    {:ok, _qa} = CMS.delete_qa(qa)

    conn
    |> put_flash(:info, "Qa deleted successfully.")
    |> redirect(to: Routes.qa_path(conn, :index))
  end
end
