defmodule ThetaWeb.Api.DataView do
  use ThetaWeb, :view

  def render("show.json", %{pages: pages}) do
    %{
      new: %{items: pages.new},
      serial: %{items: pages.serial}
    }
  end
end
