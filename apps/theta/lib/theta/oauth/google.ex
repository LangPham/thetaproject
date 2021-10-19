defmodule Google do
  @moduledoc """
  An OAuth2 strategy for Google.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode
  # http://127.0.0.1:4000/google/callback
  # https://accounts.google.com/o/oauth2/v2/auth?
  # redirect_uri=https%3A%2F%2Fdevelopers.google.com%2Foauthplayground&
  # prompt=consent&response_type=code&client_id=407408718192.apps.googleusercontent.com&
  # scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile+openid&
  # access_type=offline
  defp config do
    [
      strategy: Google,
      site: "",
      authorize_url: "https://accounts.google.com/o/oauth2/v2/auth",
      token_url: "https://oauth2.googleapis.com/token",
      redirect_uri: "http://127.0.0.1:4000/auth/google/callback"
      #      access_type: "offline"
    ]
  end

  # Public API

  def client do
    Application.get_env(:theta, Google)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    OAuth2.Client.get_token!(
      client(),
      Keyword.merge(params, client_secret: client().client_secret)
    )
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
