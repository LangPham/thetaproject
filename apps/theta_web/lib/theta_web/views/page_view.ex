defmodule ThetaWeb.PageView do
  use ThetaWeb, :view

  def markdown(body) do
    #ThetaWeb.Debug.debug(body, __MODULE__)

    body
    |> Earmark.as_html!
#    |> IO.inspect
    |> raw
  end

  def debug(body) do
    IO.inspect __MODULE__
    IO.inspect body
  end

end
