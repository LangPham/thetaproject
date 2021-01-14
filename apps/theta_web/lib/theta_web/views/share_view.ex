defmodule ThetaWeb.ShareView do
  @moduledoc false
  use Phoenix.HTML

  def time_translate(time, lang) when lang == "vi" do
    "#{time.day}/#{time.month}/#{time.year}"
  end

  def datetime_iso8601(time)do
    NaiveDateTime.to_iso8601(time)
  end

  def time_translate(_time, _lang) do
    nil
  end

  def webroot(string) do
    ThetaWeb.Endpoint.path("/" <> string)
  end

  def linktag(string) do
    ThetaWeb.Endpoint.path("/tag/" <> string)
  end

  def get_config(key) do
    var = Theta.Configuration.list_config()
    config =
      Enum.filter(var, fn x -> x.key == key  end)
    a = Enum.at(config, 0)
    a.value
  end

  def img_link(link, filter) do
    filter =
      case filter do
        "lager" -> {"lager", "750x750"}
        _ -> {"thumb", "750x500"}
      end
    path_storage = Application.get_env(:theta_media, :storage)
    list_path = Path.split(path_storage)
    {_, list_new} = List.pop_at(list_path, -1)
    path = Path.join(list_new)
    dir_upload = List.last(list_path)
    files = String.replace(link, ~r/^\/#{dir_upload}/, "/#{dir_upload}/#{elem(filter, 0)}")
    files_ext = Path.extname(files)
    files_webp = String.replace(files, ~r/#{files_ext}/, ".webp")
  end

  def img_mark(link, filter, alt) do
    filter =
      case filter do
        "lager" -> {"lager", "750x750"}
        _ -> {"thumb", "750x500"}
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
        |> IO.inspect()
        |> Mogrify.format("webp")
        |> Mogrify.save(path: Path.join(path, files_webp))
    end
    content_tag :picture do
      source = raw(
        "<source srcset=\"" <> "#{files_webp}" <> "\" type='image/webp'>"
      )
      image = raw(
        "<img src='#{link}' alt='#{alt}'>"
      )
      [source, image]
    end
  end

  defp resize_img(image, filter) do
    IO.inspect(filter)
    if elem(filter, 0) == "lager" do
      Mogrify.resize(image, "#{elem(filter, 1)}")
    else
      Mogrify.resize_to_fill(image, "#{elem(filter, 1)}")
      |> Mogrify.gravity("center")
    end
  end
end
