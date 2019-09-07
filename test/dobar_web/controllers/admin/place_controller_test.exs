defmodule DobarWeb.Admin.PlaceControllerTest do
  use DobarWeb.ConnCase

  alias Dobar.Places

  @create_attrs %{
    address: "some address",
    address2: "some address2",
    city: "some city",
    country: "some country",
    description: "some description",
    name: "some name",
    postal_code: "some postal_code",
    short_description: "some short_description",
    state: "some state",
    location: %Geo.Point{coordinates: {74.3, 44.2}, srid: 4326}
  }
  @update_attrs %{
    name: "new name"
  }
  @invalid_attrs %{}

  def fixture(:place) do
    {:ok, place} = Places.create_place(@create_attrs)
    place
  end

  describe "index" do
    test "lists all places", %{conn: conn} do
      conn = get(conn, Routes.admin_place_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Places"
    end
  end

  describe "new place" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_place_path(conn, :new))
      assert html_response(conn, 200) =~ "New Place"
    end
  end

  describe "create place" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_place_path(conn, :create), place: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_place_path(conn, :show, id)

      conn = get(conn, Routes.admin_place_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Place"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_place_path(conn, :create), place: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Place"
    end
  end

  describe "edit place" do
    setup [:create_place]

    test "renders form for editing chosen place", %{conn: conn, place: place} do
      conn = get(conn, Routes.admin_place_path(conn, :edit, place))
      assert html_response(conn, 200) =~ "Edit Place"
    end
  end

  describe "update place" do
    setup [:create_place]

    test "redirects when data is valid", %{conn: conn, place: place} do
      conn = put(conn, Routes.admin_place_path(conn, :update, place), place: @update_attrs)
      assert redirected_to(conn) == Routes.admin_place_path(conn, :show, place)

      conn = get(conn, Routes.admin_place_path(conn, :show, place))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, place: place} do
      conn = put(conn, Routes.admin_place_path(conn, :update, place), place: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Place"
    end
  end

  describe "delete place" do
    setup [:create_place]

    test "deletes chosen place", %{conn: conn, place: place} do
      conn = delete(conn, Routes.admin_place_path(conn, :delete, place))
      assert redirected_to(conn) == Routes.admin_place_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_place_path(conn, :show, place))
      end
    end
  end

  defp create_place(_) do
    place = fixture(:place)
    {:ok, place: place}
  end
end
