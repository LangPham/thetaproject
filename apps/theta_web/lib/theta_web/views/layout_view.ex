defmodule ThetaWeb.LayoutView do
  use ThetaWeb, :view

  def read_file(path) do
    case Theta.CacheDB.get(path) do
      {:ok, css} ->
        css

      {:error, _} ->
        content = find_file(path)
        Theta.CacheDB.set(path, content)
        content
    end
  end

  def find_file(path) do
    case File.read(Path.join(:code.priv_dir(:theta_web), path)) do
      {:ok, css} -> css
      {:error, _} -> ""
    end
  end
end
