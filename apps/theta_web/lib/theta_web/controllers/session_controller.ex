defmodule ThetaWeb.SessionController do
  use ThetaWeb, :controller

  alias Theta.Account
  alias ThetaWeb.Guardian

  def new(conn, _) do
#    user = Guardian.Plug.current_resource(conn)
#    user = Guardian.Plug.authenticated?(conn)
#    IO.inspect user
    conn
    |> assign(:title, "Theta - Signin")
    |> put_layout("app.html")
    |> render("new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Account.authenticate_by_email_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome #{user.name}!")
#        |> put_session(:user_id, user.id)
        |> Guardian.Plug.sign_in(user)
#        |> configure_session(renew: true)
        |> redirect(to: "/user/me")
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
#    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
