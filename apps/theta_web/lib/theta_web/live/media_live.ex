defmodule ThetaWeb.MediaLive do
	use ThetaWeb, :live_view
	use ThetaMedia

	def render(assigns) do
		Phoenix.View.render(ThetaWeb.MediaView, "layout.html", assigns)
	end

	@impl true
	def mount(_params, _session, socket) do
		base = Base.new()
		dir = Dir.list(base)
		pages = %{layout: "home.html", pwd: dir}
		IO.inspect pages, label: "PAGE===============\n"

		{:ok, assign(socket, page: pages)}
	end

	@impl true
	def handle_event("change", %{"page" => page}, socket) do
		IO.inspect page, label: "Layout========================\n"
		IO.inspect socket, label: "SOCKET========================\n"
		pages =
			case page do
				"back" ->
					pwd = socket.assigns.page.pwd
					base = Base.outgo(pwd)
					dir = Dir.list(base)
					%{layout: "home.html", pwd: dir}
				"refresh" ->
					pwd = socket.assigns.page.pwd
					dir = Dir.list(pwd)
					%{layout: "home.html", pwd: dir}
				_ ->
					base = Base.new()
					dir = Dir.list(base)
					%{layout: "home.html", pwd: dir}
			end

		IO.inspect pages, label: "PAGE UPDATE========================\n"
		{:noreply, assign(socket, :page, pages)}
	end

	@impl true
	def handle_event("into", data, socket) do
		IO.inspect "====================INTO=======================\n"
		IO.inspect socket, label: "SOCKET========================\n"
		pwd = socket.assigns.page.pwd
		dir_change = data["dir"]
		IO.inspect pwd, label: "PWD========================\n"
		IO.inspect dir_change, label: "DIR========================\n"

		base = Base.into(pwd, dir_change)

		IO.inspect base
		dir = Dir.list(base)
		IO.inspect dir, label: "DIR========================\n"
		pages = %{layout: "home.html", pwd: dir}

		{:noreply, assign(socket, :page, pages)}
	end

end
