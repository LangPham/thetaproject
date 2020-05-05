defmodule ThetaWeb.ShareView do
  @moduledoc false
  use Phoenix.HTML

  def time_translate(time, lang) when lang == "vi" do
    "#{time.day}/#{time.month}/#{time.year}"
  end

  def time_translate(_time, _lang) do
    nil
  end

  def webroot(string) do
    ThetaWeb.Endpoint.path("/"<>string)
  end

  def linktag(string) do
    ThetaWeb.Endpoint.path("/tag/" <> string)
  end

  def get_config(key) do
    var = get_all_config()
    var[key]
  end

  defp get_all_config() do
    case Theta.CacheDB.get("config") do
      {:ok, var} -> var
      {:error, _} ->
        list = Theta.Configuration.list_config()
        var = for config <- list, into: %{}, do: {config.key, config.value}
        Theta.CacheDB.set("config", var)
        var
    end
  end

end
