defmodule Dobar.PlacesTest do
  use Dobar.DataCase

  alias Dobar.Places

  describe "places" do
    alias Dobar.{Places.Place, Fixtures}

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
      assert Places.find_places() == [place]
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
end
