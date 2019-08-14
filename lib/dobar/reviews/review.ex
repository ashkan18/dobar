defmodule Dobar.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "reviews" do
    field :response, :boolean, default: false
    field :review_type, :string

    belongs_to :user, Dobar.Accounts.User
    belongs_to :place, Dobar.Places.Place

    timestamps()
  end

  @required_fields ~w(place_id user_id review_type response)a
  @review_types ~w(dobar rideshare_dobar)
  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:review_type, @review_types)
    |> foreign_key_constraint(:place_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:reviews_place_id_user_id_review_type_uniq, name: :reviews_place_id_user_id_review_type_uniq_idx)
  end
end
