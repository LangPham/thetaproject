defmodule ThetaWeb.CMS.ArticleView do
  use ThetaWeb, :view
  alias ThetaWeb.AmpCache

  def get_url_cache_amp(url) do
    AmpCache.sign_url(url)
  end

  def format_search_result(search_result, search_phrase) do
    IO.inspect search_result, label: "search_result====\n"
    IO.inspect search_phrase, label: "search_phrase====\n"
#    split_at = String.length(search_phrase)
#    {selected, rest} = String.split_at(search_result, split_at)
#
#    "<strong>#{selected}</strong>#{rest}"
    "<strong>#{search_result}</strong>"
  end
end
