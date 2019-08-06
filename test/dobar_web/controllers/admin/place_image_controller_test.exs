defmodule DobarWeb.Admin.PlaceImageControllerTest do
  use DobarWeb.ConnCase

  alias Dobar.Places

  @create_attrs %{original_url: "some original_url"}
  @update_attrs %{original_url: "some updated original_url"}
  @invalid_attrs %{original_url: nil}

  def fixture(:place_image) do
    {:ok, place_image} = Places.create_place_image(@create_attrs)
    place_image
  end

  describe "index" do
    test "lists all place_images", %{conn: conn} do
      conn = get(conn, Routes.admin_place_place_image_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Place images"
    end
  end

  describe "new place_image" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_place_place_image_path(conn, :new))
      assert html_response(conn, 200) =~ "New Place image"
    end
  end

  describe "create place_image" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_place_place_image_path(conn, :create), place_image: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_place_place_image_path(conn, :show, id)

      conn = get(conn, Routes.admin_place_place_image_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Place image"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_place_place_image_path(conn, :create), place_image: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Place image"
    end
  end

  describe "edit place_image" do
    setup [:create_place_image]

    test "renders form for editing chosen place_image", %{conn: conn, place_image: place_image} do
      conn = get(conn, Routes.admin_place_place_image_path(conn, :edit, place_image))
      assert html_response(conn, 200) =~ "Edit Place image"
    end
  end

  describe "update place_image" do
    setup [:create_place_image]

    test "redirects when data is valid", %{conn: conn, place_image: place_image} do
      conn = put(conn, Routes.admin_place_place_image_path(conn, :update, place_image), place_image: @update_attrs)
      assert redirected_to(conn) == Routes.admin_place_place_image_path(conn, :show, place_image)

      conn = get(conn, Routes.admin_place_place_image_path(conn, :show, place_image))
      assert html_response(conn, 200) =~ "some updated original_url"
    end

    test "renders errors when data is invalid", %{conn: conn, place_image: place_image} do
      conn = put(conn, Routes.admin_place_place_image_path(conn, :update, place_image), place_image: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Place image"
    end
  end

  describe "delete place_image" do
    setup [:create_place_image]

    test "deletes chosen place_image", %{conn: conn, place_image: place_image} do
      conn = delete(conn, Routes.admin_place_place_image_path(conn, :delete, place_image))
      assert redirected_to(conn) == Routes.admin_place_place_image_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.admin_place_place_image_path(conn, :show, place_image))
      end
    end
  end

  defp create_place_image(_) do
    place_image = fixture(:place_image)
    {:ok, place_image: place_image}
  end
end
