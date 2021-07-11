defmodule ThetaWeb.Media do

  def create_webp(abs_photo, save_path) do
    uri_domain = URI.parse(Application.get_env(:theta_web, :root_url))
    uri_photo = URI.parse(abs_photo)
    cond do
      uri_photo.host == nil -> webp_internal(uri_photo.path, save_path)
      uri_photo.host == uri_domain.host -> webp_internal(uri_photo.path, save_path)
      true -> abs_photo
    end
  end

  defp webp_internal(abs_photo, save_path) do
    case String.downcase(Path.extname(abs_photo)) do
      ".webp" -> fm_abs_to_rel(abs_photo)
      _ ->
        path_dir = Path.dirname(fm_rel_to_abs(save_path))
        File.mkdir_p!(path_dir)
        image =
          Gi.open(abs_photo)
          |> Gi.gm_mogrify(format: "webp")
          |> Gi.save(path: fm_rel_to_abs(save_path))
        save_path
    end
  end

  def fm_rel_to_abs(path) do
    path_storage = Application.get_env(:theta_media, :storage)
    upload_dir =
      String.split(path_storage, "/")
      |> List.last()
    path_after_uploads = Path.split(path) -- ["/", upload_dir]
                         |> Path.join()
    Path.join(path_storage, path_after_uploads)
  end

  def fm_abs_to_rel(path) do
    path_storage = Application.get_env(:theta_media, :storage)
    path_after_uploads = Path.relative_to(path, path_storage)
    upload_dir =
      String.split(path_storage, "/")
      |> List.last()
    path_after_uploads =
      Path.split(path) -- ["/", upload_dir]
      |> Path.join()
    Path.join(["/", upload_dir, path_after_uploads])
  end
end
