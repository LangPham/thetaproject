defmodule ThetaWeb.PageView do
  use ThetaWeb, :view

  def md_to_floki(body) do
    body
    |> Earmark.as_html!()
    |> Floki.parse_fragment!()
    |> create_webp()
    |> update_picture()
    |> add_id_header()
  end

  def markdown(floki) do
    floki
    |> Floki.raw_html()
    |> raw
  end

  def markdown_html(md) do
    md
    |> Earmark.as_html!()
    |> raw
  end

  def toc(floki, url) do
    floki
    |> Floki.traverse_and_update(
         fn
           {"h2", attrs, children} ->
             href = "#"<> elem(List.first( attrs), 1)
             child = {"a", [{"href", url <> href}], children}
             {"li", [], child}
           tag -> nil
         end
       )
    |> Floki.raw_html()
    |> raw
  end

  defp add_id_header(floki) do
    floki
    |> Floki.traverse_and_update(
         fn
           {"h2", attrs, children} ->
             text = Floki.text(children)
             {"h2", [{"id", Slug.slugify(text)}], children}
#           {"h3", attrs, children} ->
#             text = Floki.text(children)
#             {"h3", [{"id", Slug.slugify(text)}], children}
           tag -> tag
         end
       )
  end

  defp filter_html(floki, list_filter)do
    count = length(list_filter)
    case count do
      0 ->
        floki
      x ->
        {list_split, list_filter} = Enum.split(list_filter, 1)
        floki = Floki.filter_out(floki, Enum.at(list_split, 0))
        filter_html(floki, list_filter)
    end

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
#          IO.inspect attrs, label: "=============UPDATE PICTURE"
          attrs = attrs ++ [{"loading","lazy"}]
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
