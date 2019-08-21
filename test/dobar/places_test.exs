defmodule Dobar.PlacesTest do
  use Dobar.DataCase

  alias Dobar.{Places, Fixtures}

  describe "places" do
    alias Dobar.Places.Place

    @valid_attrs %{
      address: "some address",
      address2: "some address2",
      city: "some city",
      country: "some country",
      description: "some description",
      name: "some name",
      postal_code: "some postal_code",
      short_description: "some short_description",
      state: "some state",
      location: %Geo.Point{coordinates: {44.2, 74.3}, srid: 4326}
    }

    @update_attrs %{
      address: "some updated address",
      address2: "some updated address2",
      city: "some updated city",
      country: "some updated country",
      description: "some updated description",
      name: "some updated name",
      postal_code: "some updated postal_code",
      short_description: "some updated short_description",
      state: "some updated state",
      location: %Geo.Point{coordinates: {44.2, 74.3}, srid: 4326}
    }
    @invalid_attrs %{
      address: nil,
      address2: nil,
      city: nil,
      country: nil,
      description: nil,
      name: nil,
      postal_code: nil,
      short_description: nil,
      state: nil
    }

    test "find_places/0 returns all places" do
      place = Fixtures.create(:place)
      assert [place.id] == Enum.map(Places.find_places(), fn p -> p.id end)
    end

    test "get_place!/1 returns the place with given id" do
      place = Fixtures.create(:place)
      assert Places.get_place!(place.id) == place
    end

    test "create_place/1 with valid data creates a place" do
      assert {:ok, %Place{} = place} = Places.create_place(@valid_attrs)
      assert place.address == "some address"
      assert place.address2 == "some address2"
      assert place.city == "some city"
      assert place.country == "some country"
      assert place.description == "some description"
      assert place.name == "some name"
      assert place.postal_code == "some postal_code"
      assert place.short_description == "some short_description"
      assert place.state == "some state"
    end

    test "create_place/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Places.create_place(@invalid_attrs)
    end

    test "update_place/2 with valid data updates the place" do
      place = Fixtures.create(:place)
      assert {:ok, %Place{} = place} = Places.update_place(place, @update_attrs)
      assert place.address == "some updated address"
      assert place.address2 == "some updated address2"
      assert place.city == "some updated city"
      assert place.country == "some updated country"
      assert place.description == "some updated description"
      assert place.name == "some updated name"
      assert place.postal_code == "some updated postal_code"
      assert place.short_description == "some updated short_description"
      assert place.state == "some updated state"
    end

    test "update_place/2 with invalid data returns error changeset" do
      place = Fixtures.create(:place)
      assert {:error, %Ecto.Changeset{}} = Places.update_place(place, @invalid_attrs)
      assert place == Places.get_place!(place.id)
    end

    test "delete_place/1 deletes the place" do
      place = Fixtures.create(:place)
      assert {:ok, %Place{}} = Places.delete_place(place)
      assert_raise Ecto.NoResultsError, fn -> Places.get_place!(place.id) end
    end

    test "change_place/1 returns a place changeset" do
      place = Fixtures.create(:place)
      assert %Ecto.Changeset{} = Places.change_place(place)
    end
  end

  describe "place_images" do
    alias Dobar.Places.PlaceImage

    @valid_attrs %{urls: %{"original" => "some original_url"}}
    @update_attrs %{urls: %{"original" => "some updated original_url"}}
    @invalid_attrs %{urls: nil}

    def place_image_fixture(attrs \\ %{}) do
      user = Fixtures.create(:user)
      place = Fixtures.create(:place)

      {:ok, place_image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{place_id: place.id, uploader_id: user.id})
        |> Places.create_place_image()

      place_image
    end

    test "list_place_images/0 returns all place_images" do
      place_image = place_image_fixture()
      assert Places.list_place_images() == [place_image]
    end

    test "get_place_image!/1 returns the place_image with given id" do
      place_image = place_image_fixture()
      assert Places.get_place_image!(place_image.id) == place_image
    end

    test "create_place_image/1 with valid data creates a place_image" do
      user = Fixtures.create(:user)
      place = Fixtures.create(:place)

      assert {:ok, %PlaceImage{} = place_image} =
               Places.create_place_image(
                 Enum.into(@valid_attrs, %{place_id: place.id, uploader_id: user.id})
               )

      assert place_image.urls["original"] == "some original_url"
    end

    test "create_place_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Places.create_place_image(@invalid_attrs)
    end

    test "update_place_image/2 with valid data updates the place_image" do
      place_image = place_image_fixture()

      assert {:ok, %PlaceImage{} = place_image} =
               Places.update_place_image(place_image, @update_attrs)

      assert place_image.urls["original"] == "some updated original_url"
    end

    test "update_place_image/2 with invalid data returns error changeset" do
      place_image = place_image_fixture()
      assert {:error, %Ecto.Changeset{}} = Places.update_place_image(place_image, @invalid_attrs)
      assert place_image == Places.get_place_image!(place_image.id)
    end

    test "delete_place_image/1 deletes the place_image" do
      place_image = place_image_fixture()
      assert {:ok, %PlaceImage{}} = Places.delete_place_image(place_image)
      assert_raise Ecto.NoResultsError, fn -> Places.get_place_image!(place_image.id) end
    end

    test "change_place_image/1 returns a place_image changeset" do
      place_image = place_image_fixture()
      assert %Ecto.Changeset{} = Places.change_place_image(place_image)
    end
  end
end
