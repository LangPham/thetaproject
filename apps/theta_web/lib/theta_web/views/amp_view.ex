defmodule ThetaWeb.AmpView do
  use ThetaWeb, :view

  def md_to_floki(body) do
    body
    |> Earmark.as_html!()
    |> Floki.parse_fragment!()
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

  def toc(floki, _url) do
    floki
    |> Floki.traverse_and_update(fn
      {"h2", attrs, children} ->
        href = "" <> elem(List.first(attrs), 1)

        child = {
          "span",
          [
            {"on", "tap:#{href}.scrollTo(duration=200)"},
            {"role", "button"},
            {"tabindex", "-1"},
            {"class", "link"}
          ],
          children
        }

        {"li", [], child}

      _ ->
        nil
    end)
    |> Floki.raw_html()
    |> raw
  end

  defp add_id_header(floki) do
    floki
    |> Floki.traverse_and_update(fn
      {"h2", _attrs, children} ->
        text = Floki.text(children)
        {"h2", [{"id", Slug.slugify(text)}], children}

      #           {"h3", attrs, children} ->
      #             text = Floki.text(children)
      #             {"h3", [{"id", Slug.slugify(text)}], children}
      tag ->
        tag
    end)
  end

  defp update_picture(floki) do
    Floki.traverse_and_update(
      floki,
      fn
        {"img", attrs, _children} ->
          file = elem(List.first(attrs), 1)
          alt = elem(List.last(attrs), 1)
          file_webp = ThetaWeb.ShareView.check_image(file, {"lager", "1020x680"})

          img =
            Gi.open(ThetaWeb.Media.fm_rel_to_abs(file_webp))
            |> Gi.gm_identify()

          {
            "amp-img",
            [
              {"alt", alt},
              {"src", file_webp},
              {"width", "#{img.width}"},
              {"height", "#{img.height}"},
              {'layout', 'responsive'}
            ],
            [
              {
                "amp-img",
                [
                  {"alt", alt},
                  {"fallback", ""},
                  {"src", file},
                  {"width", "#{img.width}"},
                  {"height", "#{img.height}"},
                  {'layout', 'responsive'}
                ],
                []
              }
            ]
          }
        {"a", [{"href", href}], _children} ->
          href_edit =
            case Regex.named_captures(~r/https:\/\/theta\.vn\/(?<request>[[:print:]]+)/, href) do
              nil -> href
              %{"request" => request} ->
                root_url = Application.get_env(:theta_web, :root_url)
                "#{root_url}/#{request}"
            end
          {"a", [{"href", href_edit}], _children}
        tag ->
          tag
      end
    )
  end

  defp update_youtube(floki) do
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

        tag ->
          tag
      end
    )
  end

  def img_amp(link, filter, alt, _loading \\ "eager") do
    filter =
      case filter do
        "lager" -> {"lager", "1020x680"}
        _ -> {"thumb", "750x500"}
      end

    files_webp = ThetaWeb.ShareView.check_image(link, filter)

    content_tag :div do
      source = raw("<amp-img
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
          </amp-img>")
      [source]
    end
  end
end
