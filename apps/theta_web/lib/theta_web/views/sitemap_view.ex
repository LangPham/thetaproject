defmodule ThetaWeb.SitemapView do
  use ThetaWeb, :view

  def get_domain(page) do
    "
    <url>
      <loc>#{page.head.base}</loc>
      <changefreq>always</changefreq>
      <priority>1.0</priority>
   </url>
  "
  end

  def date(time) do
    NaiveDateTime.to_date time
  end

end
