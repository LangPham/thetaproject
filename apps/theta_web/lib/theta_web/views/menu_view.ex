defmodule ThetaWeb.MenuView do
	use ThetaWeb, :view

	def get_menu(conn) do

		menu = Theta.CMS.list_term_menu
		for m <- menu do
			%{slug: Routes.page_path(conn, :index) <> m.id, label: m.name}
		end
	end
	def get_menu_user(conn) do
		user = Guardian.Plug.current_resource(conn)
		if user do
			[
				%{slug: Routes.profile_path(conn, :index), label: "Profile"},
				%{slug: Routes.session_path(conn, :delete), label: "Logout"}
			]
		else
			nil
		end
	end
	def get_menu_cms(conn) do
		user = Guardian.Plug.current_resource(conn)
		if user.role == "ROOT" do
			[
				%{slug: Routes.user_path(conn, :index), label: "Admin User"},
				%{slug: Routes.admin_path(conn, :index), label: "Admin CMS"},
				%{slug: Routes.config_path(conn, :index), label: "Config CMS"},
				%{slug: Routes.path_alias_path(conn, :index), label: "Config alias"},
			]
		else
			[]
		end
	end

end
