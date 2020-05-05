defmodule ThetaWeb.CMS.UploadView do
  use ThetaWeb, :view

  def render("index.json", param) do
#    IO.inspect "-----view------"
    tmp = param.data
#    IO.inspect tmp.filename

#    IO.inspect ThetaWeb.Endpoint.url
    %{data: "#{tmp.filename}"}
  end

end
