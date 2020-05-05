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
  def get_menu(_) do
    Theta.PV.list_path_main_menu()
  end
  def get_tag(_) do
    Theta.PV.list_path_tag()

  end
  def get_article(_) do

      case Theta.CacheDB.get("home") do
        {:ok, var} -> var
        {:error, _} ->
          var = Theta.CMS.list_article_index()
          Theta.CacheDB.set("home", var)
          var
      end
  end
  def date(time) do

    NaiveDateTime.to_date time
  end

end
