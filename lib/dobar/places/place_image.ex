defmodule Dobar.Places.PlaceImage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "place_images" do
    field :original_url, :string
    field :place_id, :binary_id
    field :uploader_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(place_image, attrs) do
    place_image
    |> cast(attrs, [:original_url, :place_id, :uploader_id])
    |> validate_required([:original_url, :place_id, :uploader_id])
  end
end
