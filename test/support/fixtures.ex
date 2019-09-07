defmodule Dobar.Fixtures do
  alias Dobar.{Reviews, Accounts, Places}
  @review_default_attrs %{response: true, review_type: "dobar"}

  @place_default_attrs %{
    address: "some address",
    address2: "some address2",
    city: "some city",
    country: "some country",
    description: "some description",
    name: "some name",
    postal_code: "some postal_code",
    short_description: "some short_description",
    state: "some state",
    location: %Geo.Point{coordinates: {73.3, 43.2}, srid: 4326}
  }

  @user_default_attrs %{
    email: "test@dobar.com",
    name: "some name",
    password: "some password",
    username: "some username"
  }

  def create(type, attrs \\ %{})

  def create(:user, attrs) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_default_attrs)
      |> Accounts.create_user()

    user
  end

  def create(:place, attrs) do
    {:ok, place} =
      attrs
      |> Enum.into(@place_default_attrs)
      |> Places.create_place()

    place
  end

  def create(:review, attrs) do
    user = create(:user)
    place = create(:place)

    {:ok, review} =
      attrs
      |> Enum.into(@review_default_attrs)
      |> Enum.into(%{user_id: user.id, place_id: place.id})
      |> Reviews.create_review()

    review
  end
end
