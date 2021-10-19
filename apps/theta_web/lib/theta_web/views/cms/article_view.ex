defmodule ThetaWeb.CMS.ArticleView do
  use ThetaWeb, :view
  alias ThetaWeb.AmpCache

  def get_url_cache_amp(url) do
    AmpCache.sign_url(url)
  end

  def format_search_result(search_result, search_phrase) do
    "<strong>#{search_result}</strong>"
  end
end
