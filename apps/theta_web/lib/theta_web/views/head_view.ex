defmodule ThetaWeb.HeadView do
  use ThetaWeb, :view

  @doc """
    <meta charset="UTF-8">
    <meta name="description" content="Free Web tutorials">
    <meta name="keywords" content="HTML,CSS,XML,JavaScript">
    <meta name="author" content="John Doe">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta property="og:image" content="http://ia.media-imdb.com/images/rock.jpg" />
  """
  def get_meta_tag_html(head) do
    if Map.has_key?(head, :meta) do
      for meta <- head.meta do
        %{type: "meta", name: meta.name, content: meta.content}
      end
    else
      []
    end
  end

  def get_og_tag_html(head) do
    if Map.has_key?(head, :og) do
      for meta <- head.og do
        %{type: "og", property: meta.property, content: meta.content}
      end
    else
      []
    end
  end
end
