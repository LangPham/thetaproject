defmodule ThetaWeb.AmpView do
  use ThetaWeb, :view

  def md_to_floki(body) do
    body
    |> Earmark.as_html!()
    |> Floki.parse_fragment!()
    |> create_webp()
    |> update_picture()
    |> update_youtube()
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
             href = "" <> elem(List.first(attrs), 1)
             child = {"button", [{"on", "tap:#{href}.scrollTo(duration=200)"}], children}
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
    #    IO.inspect __MODULE__
    #    IO.inspect body
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
    path_storage = Application.get_env(:theta_media, :storage)
    list_path = Path.split(path_storage)
    {_, list_new} = List.pop_at(list_path, -1)
    path = Path.join(list_new)
    Floki.traverse_and_update(
      floki,
      fn
        {"img", attrs, children} ->

          file = elem(List.first(attrs), 1)
          alt = elem(List.last(attrs), 1)
          file_webp =
            file
            |> String.replace(~r/^\/#{dir_upload}/, "/#{dir_upload}/lager")
            |> String.replace(~r/(\.)(\w)+/, ".webp")
          img =
            File.read!(Path.join(path, file_webp))
            |> ExImageInfo.info
          {
            "amp-img",
            [
              {"alt", alt},
              {"src", file_webp},
              {"width", "#{elem(img, 1)}"},
              {"height", "#{elem(img, 2)}"},
              {'layout', 'responsive'}
            ],
            [
              {
                "amp-img",
                [
                  {"alt", alt},
                  {"fallback", ""},
                  {"src", file},
                  {"width", "#{elem(img, 1)}"},
                  {"height", "#{elem(img, 2)}"},
                  {'layout', 'responsive'}
                ],
                []
              },
            ]
          }
        tag -> tag
      end
    )
  end
  defp update_youtube(floki)do

    Floki.traverse_and_update(
      floki,
      fn
        {"iframe", attrs, children} ->
          videoid =
            Floki.attribute({"iframe", attrs, children}, "src")
            |> List.first()
            |> String.split("/")
            |> List.last()
          {
            "amp-youtube",
            [
              {"data-videoid", "#{videoid}"},
              {"width", "560"},
              {"height", "315"},
              {'layout', 'responsive'}
            ],
            []
          }
        tag -> tag
      end
    )
  end


  def img_amp(link, filter, alt, loading \\ "eager") do
    filter =
      case filter do
        "lager" -> {"lager", "1020x680"}
        _ -> {"thumb", "750x500"}
      end

    loading =
      case loading do
        "lazy" -> "loading=\'lazy\'"
        _ -> ""
      end
    path_storage = Application.get_env(:theta_media, :storage)
    list_path = Path.split(path_storage)
    {_, list_new} = List.pop_at(list_path, -1)
    path = Path.join(list_new)
    dir_upload = List.last(list_path)
    files = String.replace(link, ~r/^\/#{dir_upload}/, "/#{dir_upload}/#{elem(filter, 0)}")
    files_ext = Path.extname(files)
    files_webp = String.replace(files, ~r/#{files_ext}/, ".webp")
    if !File.exists?(Path.join(path, files_webp)) do
      images =
        Mogrify.open(Path.join(path, link))
        |> Mogrify.verbose
        |> resize_img(filter)
        |> Mogrify.format("webp")
        |> Mogrify.save(path: Path.join(path, files_webp))
    end
    content_tag :div do
      source = raw(
        "<amp-img
          alt='#{alt}'
          width='1020'
          height='680'
          layout='responsive'
          src='#{files_webp}'>
            <amp-img
            alt='#{alt}'
            fallback
            width='1020'
            height='680'
            layout='responsive'
            src='#{link}'>
            </amp-img>
          </amp-img>"

      )
      [source]
    end
  end

  defp resize_img(image, filter) do
    #    IO.inspect(filter)
    if elem(filter, 0) == "lager" do
      Mogrify.resize(image, "#{elem(filter, 1)}")
    else
      Mogrify.resize_to_fill(image, "#{elem(filter, 1)}")
      |> Mogrify.gravity("center")
    end
  end
end
