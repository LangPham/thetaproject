defmodule ThetaWeb.PV.PathAliasController do
	use ThetaWeb, :controller
	alias Theta.PV

	def router_path_error(conn, path_error) do
		case PV.get_path_error_path(path_error) do
			nil -> PV.create_path_error(%{path: path_error})
			       conn
			       |> assign(:title, "Not found")
			       |> put_layout(false)
			       |> put_status(:not_found)
			       |> put_view(ThetaWeb.ErrorView)
			       |> render("404.html")
			result ->
				if result.path_alias_id == nil do
					PV.update_path_error(result, %{count: result.count + 1})
					conn
					|> assign(:title, "Not found")
					|> put_layout(false)
					|> put_status(:not_found)
					|> put_view(ThetaWeb.ErrorView)
					|> render("404.html")
				else
					path = PV.get_path_alias!(result.path_alias_id)
					path_redirect =
						if path.type_model == "tags" do
							"/tag/#{path.slug}"
							else
								"/#{path.slug}"
						end
					conn
					|> put_status(301)
					|> redirect(to: path_redirect)
					|> halt()
				end
		end
	end

	def index(conn, _params) do
		path_alias = PV.list_path_error()
		render(conn, "index_error.html", path_alias: path_alias)
	end

	def create(conn, %{"path_alias" => path_alias_params}) do
		case PV.create_path_alias(path_alias_params) do
			{:ok, path_alias} ->
				conn
				|> put_flash(:info, "Path alias created successfully.")
				|> redirect(to: Routes.path_alias_path(conn, :show, path_alias))

			{:error, %Ecto.Changeset{} = changeset} ->
				render(conn, "new.html", changeset: changeset)
		end
	end

	def show(conn, %{"id" => id}) do
		path_alias = PV.get_path_alias!(id)
		render(conn, "show.html", path_alias: path_alias)
	end

	def edit(conn, %{"id" => id}) do
		path_all = PV.list_path_alias()
		path_alias = PV.get_path_error!(id)
		changeset = PV.change_path_error(path_alias)
		render(conn, "edit_error.html", path_alias: path_alias, changeset: changeset, serial: path_all)
	end

	def update(conn, %{"id" => id, "path_error" => path_error_params}) do

		path_alias = PV.get_path_error!(id)
		case PV.update_path_error(path_alias, path_error_params) do
			{:ok, _path_alias} ->
				conn
				|> put_flash(:info, "Path alias updated successfully.")
				|> redirect(to: Routes.path_alias_path(conn, :index))

			{:error, %Ecto.Changeset{} = changeset} ->
				path_all = PV.list_path_alias()
				render(conn, "edit_error.html", path_alias: path_alias, changeset: changeset, serial: path_all)
		end
	end

	def delete(conn, %{"id" => id}) do
		path_alias = PV.get_path_error!(id)
		{:ok, _path_alias} = PV.delete_path_error(path_alias)

		conn
		|> put_flash(:info, "Path error deleted successfully.")
		|> redirect(to: Routes.path_alias_path(conn, :index))
	end
end
