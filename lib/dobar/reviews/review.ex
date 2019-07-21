defmodule Dobar.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "reviews" do
    field :response, :boolean, default: false
    field :review_type, :string
    field :place_id, :binary_id
    field :user_id, :binary_id

    timestamps()
  end

  @required_fields ~w(place_id user_id review_type response)a
  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:review_type, [:dobar, :rideshare_dobar])
    |> foreign_key_constraint(:place_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:place_id, :user_id])
  end
end
