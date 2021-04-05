defmodule ThetaWeb.CMS.UploadController do
  use ThetaWeb, :controller

  alias Theta.Upload

  def index(conn, params) do
    fileUpload = params["fileUpload"]
    uriUpload = params["uriUpload"]

    IO.inspect fileUpload, label: "---- fileUpload ----"

    file_params = Upload.file_upload(fileUpload, uriUpload)
    conn
    |> render("index.json", %{data: file_params, uri: uriUpload})
  end

  def show(conn, params) do
    IO.inspect params, label: "PARAMS ======================\n"
    folder_params = params["folder"]
    file_params = params["slug"]
    file = Path.join(folder_params, file_params)
    conn
    |> render("index.json", %{data: %{filename: file}})
  end
end
