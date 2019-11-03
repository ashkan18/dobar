defmodule Dobar.PlaceImageUploader do
  use Arc.Definition

  # To add a thumbnail version:
  @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-thumbnail 250x250 -auto-orient -extent 250x250 -gravity center -format jpg",
     :jpg}
  end

  def transform(:original, _) do
    {:convert, "-auto-orient -format jpg", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, {file, _scope}) do
    "#{Path.basename(file.file_name, Path.extname(file.file_name))}_#{version}"
  end

  def storage_dir(_version, {_file, scope}) do
    "uploads/place/#{scope.id}/"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version, _scope) do
    "/uploads/place/default_#{version}.png"
  end

  def acl(:thumb, _), do: :public_read
  def acl(:original, _), do: :public_read

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
