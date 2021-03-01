defmodule ThetaWeb.Page do
  @moduledoc """

    <link rel="canonical" href="https://theta.vn" />
    <link rel="shortcut icon" href="/sites/theta.vn/themes/theta/favicon.ico" type="image/vnd.microsoft.icon">
    <base href="https://www.w3schools.com/" target="_blank">
    <meta name="title" content="Theta.vn | Góc chia sẽ kiến thức CNTT">
    <meta name="description" content="Góc chia sẽ kiến thức công nghệ thông tin, lưu giữ những bài viết hướng dẫn cài đặt cấu hình, sử hiệu quả tài nguyên ngành công nghệ thông tin!">
    <meta property="og:url" content="http://www.nytimes.com/2015/02/19/arts/international/when-great-minds-dont-think-alike.html" />
    <meta property="og:image" content="http://ia.media-imdb.com/images/rock.jpg" />
    <meta property="og:type" content="article" />
    <meta property="og:title" content="When Great Minds Don’t Think Alike" />
    <meta property="og:description" content="How much does culture influence creative thinking?" />
    <meta property="og:image" content="http://static01.nyt.com/images/2015/02/19/arts/international/19iht-btnumbers19A/19iht-btnumbers19A-facebookJumbo-v2.jpg" />
  """
  #  alias ThetaWeb.Debug
  defstruct head: %{
              # meta title og:title
              title: "Trang chủ",
              # meta description og:description
              description: "Góc chia sẽ kiến thức công nghệ thông tin, lưu giữ những bài viết hướng dẫn cài đặt cấu hình, sử hiệu quả tài nguyên ngành công nghệ thông tin!",
              # link canonical og:url
              canonical: "https://theta.vn",
              meta: [],
              og: [
                %{property: "og:image:secure_url", content: "https://theta.vn/images/logo.png"}
              ],
              # html
              base: "",
              ld_json: %{},
              img_article: ""

            },
            body: %{},
            footer: %{}

  def new(conn) do
    #Debug.debug(conn, __MODULE__)
    host = conn.host
    port = if conn.port == 80 do
      ""
    else
      ":#{conn.port}"
    end
    scheme = Application.get_env(:theta_web, ThetaWeb.Endpoint)[:scheme] <> "://"
    domain = scheme <> host <> port

    this = put_in(%__MODULE__{}.head.base, domain)
    this = put_in(
      this.head.og,
      [
        %{property: "og:image:secure_url", content: domain <> "/images/logo.png"},
        %{property: "og:image", content: domain <> "/images/logo.png"},
        %{property: "og:type", content: "website"}
      ]
    )
    put_in(this.head.canonical, domain)
    #%{ %__MODULE__{} | uri:  URI.parse(ThetaWeb.Endpoint.url)}
  end

end
