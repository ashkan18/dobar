defmodule Dobar.ReviewsTest do
  use Dobar.DataCase

  alias Dobar.Reviews

  describe "reviews" do
    alias Dobar.Reviews.Review
    alias Dobar.Fixtures

    @valid_attrs %{response: true, review_type: "dobar"}
    @update_attrs %{response: false, review_type: "rideshare_dobar"}
    @invalid_attrs %{response: nil, review_type: nil}

    test "list_reviews/0 returns all reviews" do
      review = Fixtures.create(:review)
      assert Reviews.list_reviews() == [review]
    end

    test "get_review!/1 returns the review with given id" do
      review = Fixtures.create(:review)
      assert Reviews.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review" do
      user = Fixtures.create(:user)
      place = Fixtures.create(:place)

      assert {:ok, %Review{} = review} =
               @valid_attrs
               |> Enum.into(%{place_id: place.id, user_id: user.id})
               |> Reviews.create_review()

      assert review.response == true
      assert review.review_type == "dobar"
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reviews.create_review(@invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = Fixtures.create(:review)
      assert {:ok, %Review{} = review} = Reviews.update_review(review, @update_attrs)
      assert review.response == false
      assert review.review_type == "rideshare_dobar"
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = Fixtures.create(:review)
      assert {:error, %Ecto.Changeset{}} = Reviews.update_review(review, @invalid_attrs)
      assert review == Reviews.get_review!(review.id)
    end

    test "change_review/1 returns a review changeset" do
      review = Fixtures.create(:review)
      assert %Ecto.Changeset{} = Reviews.change_review(review)
    end
  end
end
