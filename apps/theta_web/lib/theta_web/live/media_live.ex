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

		{:ok, assign(socket, page: pages)}
	end

	@impl true
	def handle_event("change", %{"page" => page}, socket) do
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

		{:noreply, assign(socket, :page, pages)}
	end

	@impl true
	def handle_event("into", data, socket) do
		pwd = socket.assigns.page.pwd
		dir_change = data["dir"]
		base = Base.into(pwd, dir_change)
		dir = Dir.ls(base)
		pages = %{layout: "home.html", pwd: dir}
		{:noreply, assign(socket, :page, pages)}
	end

	@impl true
	def handle_event("create", %{"q" => query}, socket) do
		pwd = socket.assigns.page.pwd
		Dir.mkdir(pwd,query)
		dir = Dir.ls(pwd)
		pages = %{layout: "home.html", pwd: dir}
		{:noreply, assign(socket, :page, pages)}
	end

	@impl true
	def handle_event("upload", %{"q" => query}, socket) do
		pwd = socket.assigns.page.pwd
		dir = Dir.ls(pwd)
		pages = %{layout: "home.html", pwd: dir}
		{:noreply, assign(socket, :page, pages)}
	end

end
