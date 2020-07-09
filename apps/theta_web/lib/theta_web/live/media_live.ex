defmodule ThetaWeb.MediaLive do
	use ThetaWeb, :live_view
	use ThetaMedia

	@impl true
	def render(assigns) do
		Phoenix.View.render(ThetaWeb.MediaView, "layout.html", assigns)
	end

	@impl true
	def mount(_params, _session, socket) do
		base = Base.new()
		dir = Dir.ls(base)
		pages = %{layout: "home.html", pwd: dir}
#		IO.inspect pages, label: "PAGE===============\n"

		{:ok, assign(socket, page: pages)}
	end

	@impl true
	def handle_event("change", %{"page" => page}, socket) do
#		IO.inspect page, label: "Layout========================\n"
#		IO.inspect socket, label: "SOCKET========================\n"
		pages =
			case page do
				"back" ->
					pwd = socket.assigns.page.pwd
					base = Base.outgo(pwd)
					dir = Dir.ls(base)
					%{layout: "home.html", pwd: dir}
				"refresh" ->
					pwd = socket.assigns.page.pwd
					dir = Dir.ls(pwd)
					%{layout: "home.html", pwd: dir}
				"new" ->
					pwd = socket.assigns.page.pwd
					dir = Dir.ls(pwd)
					%{layout: "new.html", pwd: dir}
				"upload" ->
					pwd = socket.assigns.page.pwd
					dir = Dir.ls(pwd)
					%{layout: "upload.html", pwd: dir}
				_ ->
					base = Base.new()
					dir = Dir.ls(base)
					%{layout: "home.html", pwd: dir}
			end

#		IO.inspect pages, label: "PAGE UPDATE========================\n"
		{:noreply, assign(socket, :page, pages)}
	end

	@impl true
	def handle_event("into", data, socket) do
#		IO.inspect "====================INTO=======================\n"
#		IO.inspect socket, label: "SOCKET========================\n"
		pwd = socket.assigns.page.pwd
		dir_change = data["dir"]
#		IO.inspect pwd, label: "PWD========================\n"
#		IO.inspect dir_change, label: "DIR========================\n"

		base = Base.into(pwd, dir_change)

#		IO.inspect base
		dir = Dir.ls(base)
#		IO.inspect dir, label: "DIR========================\n"
		pages = %{layout: "home.html", pwd: dir}

		{:noreply, assign(socket, :page, pages)}
	end

	@impl true
	def handle_event("create", %{"q" => query}, socket) do
#		IO.inspect query, label: "Query"
#		IO.inspect socket, label: "SOCKET===============\n"
		pwd = socket.assigns.page.pwd
		Dir.mkdir(pwd,query)
		dir = Dir.ls(pwd)
		pages = %{layout: "home.html", pwd: dir}
		{:noreply, assign(socket, :page, pages)}
	end

	@impl true
	def handle_event("upload", %{"q" => query}, socket) do
#		IO.inspect query, label: "Query"
#		IO.inspect File.stat(query)
#		IO.inspect socket, label: "SOCKET===============\n"
		pwd = socket.assigns.page.pwd
		dir = Dir.ls(pwd)

		pages = %{layout: "home.html", pwd: dir}
		{:noreply, assign(socket, :page, pages)}
	end
#	@impl true
#	def terminate(reason, socket) do
#		:kill
#	end

end
