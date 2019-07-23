defmodule DobarWeb.Resolvers.ReviewResolver do
  alias Dobar.Reviews

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
end
