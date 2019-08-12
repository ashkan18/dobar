defmodule Dobar.Places.PlaceImage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "place_images" do
    field :urls, :map
    field :place_id, :binary_id
    field :uploader_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(place_image, attrs) do
    place_image
    |> cast(attrs, [:urls, :place_id, :uploader_id])
    |> validate_required([:urls, :place_id, :uploader_id])
  end
end
