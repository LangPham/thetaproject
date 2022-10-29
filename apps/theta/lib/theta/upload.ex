defmodule Theta.Upload do
  @moduledoc """
  The Upload context.
  """

  def file_upload(upload, uri) do
    extension = Path.extname(upload.filename)
    rootname = Path.rootname(upload.filename)
    rootname = Slug.slugify("#{rootname}")
    file_name = "#{rootname}#{extension}"

    dir = uri
    pipeFile = "/#{dir}/#{file_name}"

    File.mkdir_p(dir)
    File.cp(upload.path, "#{dir}/#{file_name}")

    %{filename: pipeFile}
  end
end
