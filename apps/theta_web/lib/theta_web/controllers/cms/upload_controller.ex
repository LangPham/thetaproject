defmodule ThetaWeb.CMS.UploadController do
  use ThetaWeb, :controller

  alias Theta.Upload

  def index(conn, params) do
#    IO.inspect Guardian.Plug.session_active?(conn), lable: "Active ======\n"
#    IO.inspect conn
#    {_, cookie} = List.keyfind(conn.req_headers, "cookie", 0)
#
#    list_cookie = String.split(cookie, ";")
#    IO.inspect list_cookie
#
#    cookie_theta = Enum.filter(list_cookie, fn x -> String.match?(x, ~r/_theta_web_key/) end)
#    IO.inspect cookie_theta
#    cookie_string = List.last(String.split(List.last(cookie_theta), "="))
#    IO.inspect cookie_string
#    IO.inspect Guardian.Token.decode_token(cookie_string), lable: "=================\n"
#    IO.inspect Plug.Conn.get_session(conn)

    fileUpload = params["fileUpload"]

    IO.inspect "---- fileUpload ----"
    IO.inspect fileUpload

    file_params = Upload.file_upload(fileUpload)
    conn
    |> render("index.json", %{data: file_params})
  end
end
