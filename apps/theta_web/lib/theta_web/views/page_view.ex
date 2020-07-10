defmodule ThetaWeb.PageView do
	use ThetaWeb, :view

	def markdown(body) do
		#ThetaWeb.Debug.debug(body, __MODULE__)

		body
		#    |> IO.inspect
		#    |> Earmark.as_html!
		#    |> IO.inspect
		#    |> raw
		html = Earmark.as_html!(body)
		fh = Floki.parse_fragment!(html)
		imgs = Floki.find(fh, "img")
		srcs = Floki.attribute(imgs, "src")
		#      IO.inspect srcs
		path_storage = Application.get_env(:theta_media, :storage)
		list_path = Path.split(path_storage)
		{_, list_new} = List.pop_at(list_path, -1)
		path = Path.join(list_new)
		#		IO.inspect srcs

		for file <- srcs do
			files = String.replace(file, ~r/^\/uploads/, "/uploads/lager")
			IO.inspect  Path.join(path, file)
			if !File.exists?(Path.join(path, files)) do
				images =
					Mogrify.open(Path.join(path, file))
					|> Mogrify.verbose
					|> Mogrify.resize("748x748")
					|> Mogrify.save(path: Path.join(path, files))
			end
		end
		fh1 = Floki.attr(fh, "img", "src", fn (src) -> String.replace(src, ~r/^\/uploads/, "/uploads/lager/") end)
		html1 = Floki.raw_html(fh1)
		raw(html1)
	end

	def debug(body) do
		IO.inspect __MODULE__
		IO.inspect body
	end

end
