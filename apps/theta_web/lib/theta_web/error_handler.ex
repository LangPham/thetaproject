defmodule ThetaWeb.ErrorHandler do
  defexception [:message]
  use ThetaWeb, :controller
  alias Theta.PV

  def process_error(conn)do
    path = conn.request_path
    case PV.get_path_error_by_path(path) do
      nil -> PV.create_path_error(%{"path" => path})
      path_error ->
        if path_error.redirect do
          conn
          |> put_status(301)
          |> redirect(to: path_error.redirect)
        else
          count = path_error.count + 1
          PV.update_path_error(path_error, %{"count" => count})
        end
    end
  end
end

defimpl Plug.Exception, for: ThetaWeb.ErrorHandler do
  def status(exception) do
    case Integer.parse(exception.message) do
      :error -> 404
      {int, _} -> int
    end
  end
end

defimpl Plug.Exception, for: Cap.ErrorHandler do
  def status(exception) do
    case Integer.parse(exception.message) do
      :error -> 404
      {int, _} -> 403
    end
  end
end
