defmodule ThetaWeb.PageView do
	use ThetaWeb, :view

	def markdown(body) do
		# ThetaWeb.Debug.debug(body, __MODULE__)
		body
		|> Earmark.as_html!()
		|> Floki.parse_fragment!()
		|> create_webp()
		|> update_picture()
		|> Floki.raw_html()
		|> raw

	end





	def debug(body) do
		IO.inspect __MODULE__
		IO.inspect body
	end


	defp create_webp(floki) do
		path_storage = Application.get_env(:theta_media, :storage)
		list_path = Path.split(path_storage)
		{_, list_new} = List.pop_at(list_path, -1)
		path = Path.join(list_new)
		dir_upload = List.last(list_path)

		list =
			floki
			|> Floki.find("img")
			|> Floki.attribute("src")

		for file <- list do
			files = String.replace(file, ~r/^\/#{dir_upload}/, "/#{dir_upload}/lager")
			files_ext = Path.extname(files)
			files_webp = String.replace(files, ~r/#{files_ext}/, ".webp")

			if !File.exists?(Path.join(path, files_webp)) do
				images =
					Mogrify.open(Path.join(path, file))
					|> Mogrify.verbose
					|> Mogrify.resize("750x750")
					|> Mogrify.format("webp")
					|> Mogrify.save(path: Path.join(path, files_webp))
			end
		end
		{floki, dir_upload}
	end

	defp update_picture({floki, dir_upload})do
		Floki.traverse_and_update(
			floki,
			fn
				{"img", attrs, children} ->
					file = elem(List.first(attrs), 1)
					file_webp =
						file
						|> String.replace(~r/^\/#{dir_upload}/, "/#{dir_upload}/lager")
						|> String.replace(~r/(\.)(\w)+/, ".webp")
					{
						"picture",
						[],
						[
							{
								"source",
								[
									{"srcset", file_webp},
									{"type", "image/webp"}
								],
								[]
							},
							{"img", attrs, []}
						]
					}
				tag -> tag
			end
		)
	end
end
