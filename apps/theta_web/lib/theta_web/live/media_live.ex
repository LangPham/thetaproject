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
		IO.inspect dir, label: "DIR===============\n"
		{:ok, assign(socket, page: "home.html", dir: dir, base: base)}
	end

	@impl true
	def handle_event("change", %{"page" => page}, socket) do
		IO.inspect page
		template =
				if page == "home" do
					"home.html"
				else
					"new.html"
				end
		{:noreply, assign(socket, :page, template)}
	end

	@impl true
	def handle_event("into", data, socket) do
		IO.inspect socket.assigns.base, lable: "Socket:"
		IO.inspect data["dir"], lable: "Run into data:"
		base = socket.assigns.base
		dir = data["dir"]
		base = Base.into(base,dir)

		IO.inspect base
		dir = Dir.list(base)
#		template =
#			if dir == "home" do
#				"home.html"
#			else
#				"new.html"
#			end
#		{:noreply, assign(socket, :page, "home.html")}
		{:noreply, assign(socket, page: "home.html", dir: dir, base: base)}
	end

end
