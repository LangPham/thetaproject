defmodule ThetaWeb.AmpCache do
  @moduledoc """
    ThetaWeb.AmpCache.sign_url "huong-dan-drupal-7-20200304153313.html"

    Read more: https://developers.google.com/amp/cache/update-cache
    echo -n > url.txt "/update-cache/c/s/example.com/article?amp_action=flush&amp_ts=$(date +%s)" && cat url.txt | openssl dgst -sha256 -sign private-key.pem > signature.bin
  """
  def sign_url(url_origin) do
    prefix_amp = "www.theta.vn/amp/"
    url_origin = "#{prefix_amp}#{url_origin}"

    amp_ts =
      DateTime.now!("Etc/UTC")
      |> DateTime.to_unix()

    url = "/update-cache/c/s/#{url_origin}?amp_action=flush&amp_ts=#{amp_ts}"
    Path.join(:code.priv_dir(:theta_web), "cert/private-key.pem")

    {:ok, rsa_private_key} =
      File.read(Path.join(:code.priv_dir(:theta_web), "cert/private-key.pem"))

    {:ok, signature} = RsaEx.sign(url, rsa_private_key)
    {:ok, rsa_public_key} = File.read(Path.join(:code.priv_dir(:theta_web), "cert/apikey.pub"))

    base64 = Base.url_encode64(signature, padding: false)

    prefix = "https://www-theta-vn.cdn.ampproject.org"
    "#{prefix}#{url}&amp_url_signature=#{base64}"
  end
end
