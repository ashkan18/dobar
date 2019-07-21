defmodule DobarWeb.Resolvers.ReviewResolver do
  alias Dobar.Reviews

  def dobar(_parent, %{place_id: place_id, response: response}, %{
        context: %{current_user: current_user}
      }) do
    Reviews.create_review(%{
      place_id: place_id,
      user_id: current_user.id,
      review_type: :dobar,
      response: response
    })
  end

  def rideshare_dobar(_parent, %{place_id: place_id, response: response}, %{
        context: %{current_user: current_user}
      }) do
    Reviews.create_review(%{
      place_id: place_id,
      user_id: current_user.id,
      review_type: :rideshare_dobar,
      response: response
    })
  end
end
