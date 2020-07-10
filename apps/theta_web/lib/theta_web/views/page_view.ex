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
			files_ext = Path.extname(files)
			files_webp = String.replace(files, ~r/#{files_ext}/, ".webp")
			#			Regex.match?(~r/\.(\w)/, ".foo2")
			#			IO.inspect  Path.join(path, files_webp)
			if !File.exists?(Path.join(path, files_webp)) do
				images =
					Mogrify.open(Path.join(path, file))
					|> Mogrify.verbose
					|> Mogrify.resize("748x748")
					|> Mogrify.format("webp")
						#					|> IO.inspect
					|> Mogrify.save(path: Path.join(path, files_webp))
			end
		end
#		fh1 =
#			Floki.attr(
#				fh,
#				"img",
#				"src",
#				fn (src) ->
#					String.replace(src, ~r/^\/uploads/, "/uploads/lager")
#					|> String.replace(~r/(\.)(\w)+/, ".webp")
#				end
#			)
		#		html = {"div", [], ["hello"]}
		#		Floki.traverse_and_update(html, fn {"div", attrs, children} ->
		#			{"p", attrs, children}
		#		end)
		#		{"p", [], ["hello"]}
		#			<picture>
		#				<source srcset="exam.webp" type="image/webp">
		#				<img src="exam.png" />
		#			</picture>
		IO.inspect fh
#		ht = {
#			"p",
#			[],
#			[
#				"\n asdsad  ",
#				{"img", [{"src", "/uploads/2020/3/Cai-dat-nginx-voi-brew-1583405629975273700.png"}, {"alt", ""}], []}
#			]
#		}
		ta = Floki.traverse_and_update(
			fh,
			fn
				{"img", attrs, children} ->
					file = elem(List.first(attrs), 1)
					file_webp =
						file
						|> String.replace(~r/^\/uploads/, "/uploads/lager")
						|> String.replace(~r/(\.)(\w)+/, ".webp")
#						|> IO.inspect label: "ATT===== \n"
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
		IO.inspect ta, label: "Ketqua =========\n"
#		html1 = Floki.raw_html(fh1)
		html1 = Floki.raw_html(ta)
		#		IO.inspect html1
		raw(html1)
	end

	def debug(body) do
		IO.inspect __MODULE__
		IO.inspect body
	end

end
