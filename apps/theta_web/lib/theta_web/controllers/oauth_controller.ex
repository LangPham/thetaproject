defmodule ThetaWeb.OauthController do
	use ThetaWeb, :controller

	alias Theta.{Account}
	alias ThetaWeb.Guardian

	@doc """
	This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
	based on the chosen strategy.
	"""
	def index(conn, %{"provider" => provider}) do
		#    IO.inspect conn
		#    IO.inspect authorize_url!(provider)

		#    redirect(conn, external: "https://google.com")
		redirect(conn, external: authorize_url!(provider))
	end


	@doc """
	This action is reached via `/auth/:provider/callback` is the the callback URL that
	the OAuth2 provider will redirect the user back to with a `code` that will
	be used to request an access token. The access token will then be used to
	access protected resources on behalf of the user.
	"""
	def callback(conn, %{"provider" => provider, "code" => code}) do
		client = get_token!(provider, code)
		user = get_user!(provider, client)
		#    IO.inspect user
		credential = check_exit_credential(provider, user)
		conn
		|> put_flash(:info, "Welcome back!")
		|> put_session(:people_id, credential.people_id)
		|> configure_session(renew: true)
		|> Guardian.Plug.sign_in(credential)
		|> redirect(to: "/")

	end

	defp authorize_url!("google") do
    Google.authorize_url!(
			[scope: "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"]
		)
	end
	defp authorize_url!(_), do: raise "No matching provider available"

	defp get_token!("google", code), do: Google.get_token!(code: code)
	defp get_token!(_, _), do: raise "No matching provider available"

	defp get_user!("google", client) do
		#		IO.inspect is_binary("https://www.googleapis.com/userinfo/v2/me")
		%{body: user, status_code: _status} = OAuth2.Client.get!(
			client,
			"https://www.googleapis.com/userinfo/v2/me"
		)
		#		access_token = Jason.decode!(client.token.access_token)
		#    IO.inspect(user, label: "user =======================\n")
		#    IO.inspect(status, label: "status =======================\n")
		#		%{
		#			"email" => "phamxuanlang@gmail.com",
		#			"family_name" => "Pham",
		#			"given_name" => "Lang",
		#			"id" => "104170134775893014093",
		#			"locale" => "vi",
		#			"name" => "Lang Pham",
		#			"picture" => "https://lh3.googleusercontent.com/a-/AOh14Gh36ht1UYOfVCH_nW-f-_VKIL_e9Ssu0kCcojeeSw",
		#			"verified_email" => true
		#		}

		%{
			email: user["email"],
			family_name: user["family_name"],
			given_name: user["given_name"],
			google_id: user["id"],
			locale: user["locale"],
			name: user["name"],
			picture: user["picture"],
			verified_email: user["verified_email"],
		}
	end
	defp check_exit_credential(provider, user) when provider == "google" do
		google_email = user.email
		case Account.get_credential_by_google_email(google_email) do
			nil ->
				Account.create_user(%{name: user.name, username: user.google_id, role: "USER", avatar: user.picture})
			credential -> credential
		end
	end
	defp check_exit_credential(_provider, _user), do: false
end