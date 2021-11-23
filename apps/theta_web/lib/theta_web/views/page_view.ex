defmodule ThetaWeb.PageView do
  use ThetaWeb, :view

  def md_to_floki(body) do
    body
    |> Earmark.as_html!()
    |> Floki.parse_fragment!()
    |> update_picture()
    |> add_id_header()
#    |> IO.inspect(label: "Floki======\n")
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
    |> Floki.traverse_and_update(fn
      {"h2", attrs, children} ->
        href = "#" <> elem(List.first(attrs), 1)
        child = {"a", [{"href", url <> href}], children}
        {"li", [{"class", "py-2"}], child}

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

  defp filter_html(floki, list_filter) do
    count = length(list_filter)

    case count do
      0 ->
        floki

      _ ->
        {list_split, list_filter} = Enum.split(list_filter, 1)
        floki = Floki.filter_out(floki, Enum.at(list_split, 0))
        filter_html(floki, list_filter)
    end
  end

  defp update_picture(floki) do
    Floki.traverse_and_update(
      floki,
      fn
        {"img", attrs, _children} ->
          file = elem(List.first(attrs), 1)

          file_webp = ThetaWeb.ShareView.check_image(file, {"lager", "1020x680"})

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
        {"a", [{"href", href}], _children} ->
          href_edit =
          case Regex.named_captures(~r/https:\/\/theta\.vn(?<request>[[:print:]]+)/, href) do
            nil -> href
            %{"request" => request} ->
                     root_url = Application.get_env(:theta_web, :root_url)
                     "#{root_url}/request"
          end
          {"a", [{"href", href_edit}], _children}
        tag ->
          tag
      end
    )
  end
end
