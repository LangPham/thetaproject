defmodule ThetaWeb.ShareView do
  @moduledoc false
  use Phoenix.HTML

  def add_stt(list) do
    count = length(list) - 1
    if count >= 0 do
      for index <- 0..count do
        Map.put_new(Enum.at(list, index), :stt, index + 1)
      end
    end

  end

  def time_translate(time, lang) when lang == "vi" do
    "#{time.day}/#{time.month}/#{time.year}"
  end

  def time_translate(time, _lang) do
    "#{time.day}/#{time.month}/#{time.year}"
  end

  def datetime_iso8601(time)do
    NaiveDateTime.to_iso8601(time)
  end

  def webroot(string) do
    ThetaWeb.Endpoint.path("/" <> string)
  end


  def get_config(key) do
    var = Theta.Configuration.list_config()
    config =
      Enum.filter(var, fn x -> x.key == key  end)
    a = Enum.at(config, 0)
    a.value
  end

  def img_link(link, filter) do
    uri = URI.parse(link)
    filter =
      case filter do
        "lager" -> {"lager", "750x750"}
        _ -> {"thumb", "750x500"}
      end
    path_storage = Application.get_env(:theta_media, :storage)
    list_path = Path.split(path_storage)
    #    {_, list_new} = List.pop_at(list_path, -1)
    #    path = Path.join(list_new)
    dir_upload = List.last(list_path)

    url =
      if is_nil(uri.authority) do
        link
      else
        uri.path
      end

    files = String.replace(url, ~r/^\/#{dir_upload}/, "/#{dir_upload}/#{elem(filter, 0)}")
    files_ext = Path.extname(files)
    String.replace(files, ~r/#{files_ext}/, ".webp")
  end

  def img_mark(link, filter, alt, loading \\ "eager") do
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

    files_webp = check_image(link, filter)

    content_tag :picture do
      source = raw(
        "<source srcset=\"" <> "#{files_webp}" <> "\" type='image/webp'>"
      )
      image = raw(
        "<img src='#{link}' alt='#{alt}' #{loading}>"
      )
      [source, image]
    end

  end

  def check_image(link, filter) do
    path_storage = Application.get_env(:theta_media, :storage)
    upload_dir =
      String.split(path_storage, "/")
      |> List.last()
    abs_link = Path.expand("..#{link}", path_storage)
    files_webp =
      link
      |> String.replace(~r/(\.)(\w)+/, ".webp")
      |> String.replace(~r/(\/#{upload_dir}\/)/, "/#{upload_dir}/#{elem(filter, 0)}/")
    abs_webp = Path.expand("..#{files_webp}", path_storage)

    if !File.exists?(abs_webp) do
      ThetaWeb.Media.create_webp(abs_link,files_webp)
    end
    files_webp
  end


end
