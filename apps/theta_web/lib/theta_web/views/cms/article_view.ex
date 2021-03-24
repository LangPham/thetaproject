defmodule ThetaWeb.CMS.ArticleView do
  use ThetaWeb, :view
  alias ThetaWeb.AmpCache

  def get_url_cache_amp(url) do
    AmpCache.sign_url(url)
  end
end
