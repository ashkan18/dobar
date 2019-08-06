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

  def create(conn, %{"place_id" => place_id, "place_image" => %{"original_url" => original_file} }) do
    with place <- Places.get_place!(place_id),
        {:ok, file} <- PlaceImageUploader.store({original_file, place}),
        original_url <- PlaceImageUploader.url({file, place}, :original),
        {:ok, place_image} <- Places.create_place_image(%{original_url: original_url, place_id: place.id, uploader_id: "d1d71d2b-55b4-42af-8e80-7bf582c7acda"}) do # uploader_id: Guardian.Plug.current_resource(conn).id}) do
      conn
      |> put_flash(:info, "Place image created successfully.")
      |> redirect(to: Routes.admin_place_place_image_path(conn, :index, place_image.place_id))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, place_id: place_id)
    end
  end

  def show(conn, %{"id" => id}) do
    place_image = Places.get_place_image!(id)
    render(conn, "show.html", place_image: place_image)
  end

  def edit(conn, %{"id" => id}) do
    place_image = Places.get_place_image!(id)
    changeset = Places.change_place_image(place_image)
    render(conn, "edit.html", place_image: place_image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "place_image" => place_image_params}) do
    place_image = Places.get_place_image!(id)

    case Places.update_place_image(place_image, place_image_params) do
      {:ok, place_image} ->
        conn
        |> put_flash(:info, "Place image updated successfully.")
        |> redirect(to: Routes.admin_place_place_image_path(conn, :show, place_image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", place_image: place_image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    place_image = Places.get_place_image!(id)
    {:ok, _place_image} = Places.delete_place_image(place_image)

    conn
    |> put_flash(:info, "Place image deleted successfully.")
    |> redirect(to: Routes.admin_place_place_image_path(conn, :index, place_image.place_id))
  end
end
