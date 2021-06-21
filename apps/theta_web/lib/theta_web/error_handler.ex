defmodule ThetaWeb.ErrorHandler do
  defexception [:message]

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