defmodule ThetaWeb.CMS.UploadView do
  use ThetaWeb, :view

  def render("index.json", param) do
    tmp = param.data
    uri = param.uri
    %{data: "#{tmp.filename}", uri: uri}
  end

end
