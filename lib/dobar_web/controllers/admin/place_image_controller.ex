defmodule DobarWeb.Admin.PlaceImageController do
  use DobarWeb, :controller

  alias Dobar.{Repo, PlaceImageUploader, Places, Places.PlaceImage}

  def index(conn, %{"place_id" => place_id}) do
    place = Places.get_place!(place_id) |> Repo.preload(:images)
    render(conn, "index.html", place_images: place.images, place_id: place_id)
  end

  def new(conn, %{"place_id" => place_id}) do
    changeset = Places.change_place_image(%PlaceImage{place_id: place_id})
    render(conn, "new.html", changeset: changeset, place_id: place_id)
  end

  def create(conn, %{"place_id" => place_id, "place_image" => %{"image_file" => image_file}}) do
    with place <- Places.get_place!(place_id),
         {:ok, file} <- PlaceImageUploader.store({image_file, place}),
         urls <- PlaceImageUploader.urls({file, place}),
         {:ok, place_image} <-
           Places.create_place_image(%{
             urls: urls,
             place_id: place.id,
             uploader_id: Guardian.Plug.current_resource(conn).id
           }) do
      conn
      |> put_flash(:info, "Place image created successfully.")
      |> redirect(to: Routes.admin_place_place_image_path(conn, :index, place_image.place_id))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, place_id: place_id)

      {:error, _} ->
        nil
    end
  end

  def show(conn, %{"id" => id}) do
    place_image = Places.get_place_image!(id)
    render(conn, "show.html", place_image: place_image)
  end

  def delete(conn, %{"id" => id}) do
    place_image = Places.get_place_image!(id)
    {:ok, _place_image} = Places.delete_place_image(place_image)

    conn
    |> put_flash(:info, "Place image deleted successfully.")
    |> redirect(to: Routes.admin_place_place_image_path(conn, :index, place_image.place_id))
  end
end
