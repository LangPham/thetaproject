defmodule ThetaWeb.MediaController do
	use ThetaWeb, :controller

	use ThetaMedia
	def index(conn, _params) do
		base = Base.new()
		dir = Dir.list(base)
		IO.inspect dir, label: "DIR===============\n"
		render(conn, "index.html", dir: dir)
	end
end