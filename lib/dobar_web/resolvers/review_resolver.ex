defmodule DobarWeb.Resolvers.ReviewResolver do
  alias Dobar.Reviews
  alias Dobar.Places.Place

  def dobar(_parent, %{place_id: place_id, response: response}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Reviews.create_review(%{
      place_id: place_id,
      user_id: user_id,
      review_type: "dobar",
      response: response
    })
  end

  def dobar(_parent, _args, _context), do: {:error, "Not Authorized"}

  def rideshare_dobar(_parent, %{place_id: place_id, response: response}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Reviews.create_review(%{
      place_id: place_id,
      user_id: user_id,
      review_type: "rideshare_dobar",
      response: response
    })
  end

  def rideshare_dobar(_parent, _args, _context), do: {:error, "Not Authorized"}

  def place_stats(place, _args, _context) do
    {:ok, Reviews.place_stats(place.id)}
  end

  def user_place_reviews(%Place{id: place_id}, _args, %{context: %{current_user: %{id: user_id}}}) do
    {:ok, Reviews.user_place_reviews(user_id, place_id)}
  end

  def user_place_reviews(_place, _args, _), do: {:ok, nil}
end
