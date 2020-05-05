defmodule Theta.Upload do
  @moduledoc """
  The Upload context.
  """
  alias Ecto.Changeset

  @dir "uploads"
  def file_upload(upload) do

    extension = Path.extname(upload.filename)
    rootname = Path.rootname(upload.filename)
    rootname = Slugger.slugify("#{rootname}_#{:os.system_time()}")
    file_name = "#{rootname}#{extension}"
    navDT = NaiveDateTime.add(NaiveDateTime.utc_now, 7 * 3600)
    dir = "#{@dir}/#{navDT.year()}/#{navDT.month()}/"
    pipeFile = "/#{@dir}/#{navDT.year()}/#{navDT.month()}/#{file_name}"
    File.mkdir_p(dir)
    File.cp(upload.path, "#{dir}/#{file_name}")
    %{filename: pipeFile}
  end
  def file_upload(%Ecto.Changeset{valid?: false} = changeset, _sources), do: changeset
  def file_upload(changeset, sources) do
    if changeset.data.id == nil do
      new_file_upload(changeset, sources)
    else

      edit_file_upload(changeset, sources)
    end
  end

  defp new_file_upload(changeset, sources) do
    if Map.has_key?(changeset.changes, sources) do

      store_file(changeset, sources)
    else
      changeset
    end
  end
  defp edit_file_upload(changeset, sources) do
    if Map.has_key?(changeset.changes, sources) do
      file_old = Map.get(changeset.data, sources)
      delete_file(file_old)
      store_file(changeset, sources)
    else
      changeset
    end
  end

  defp store_file(changeset, sources) do
    upload = Map.get(changeset.changes, sources)
    extension = Path.extname(upload.filename)
    rootname = Path.rootname(upload.filename)
    rootname = Slugger.slugify("#{rootname}_#{:os.system_time()}")
    file_name = "#{rootname}#{extension}"
    navDT = NaiveDateTime.add(NaiveDateTime.utc_now, 7 * 3600)
    dir = "#{@dir}/#{navDT.year()}/#{navDT.month()}/"
    pipeFile = "/#{@dir}/#{navDT.year()}/#{navDT.month()}/#{file_name}"
    File.mkdir_p(dir)
    File.cp(upload.path, "#{dir}/#{file_name}") # your phoenix project dir
    Changeset.change(changeset, photo: pipeFile)
  end
  def delete_file(string) do
    file_remove = string
    if File.exists?(file_remove) do
      File.rm(file_remove)
    end
  end
end
