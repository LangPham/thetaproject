defmodule ThetaWeb.Api.DataView do
  use ThetaWeb, :view

  def render("show.json", %{pages: pages}) do

#    %{items: pages}
    %{
      new: %{items: pages.new},
      serial: %{items: pages.serial},
    }

  end

end
