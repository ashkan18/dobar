defmodule DobarWeb.Admin.PlaceController do
  use DobarWeb, :controller

  alias Dobar.Places
  alias Dobar.Places.Place

  def index(conn, _params) do
    places = Places.find_places()
    render(conn, "index.html", places: places)
  end

  def new(conn, _params) do
    changeset = Places.change_place(%Place{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"place" => place_params}) do
    case Places.create_place(place_params) do
      {:ok, place} ->
        conn
        |> put_flash(:info, "Place created successfully.")
        |> redirect(to: Routes.admin_place_path(conn, :show, place))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    place = Places.get_place!(id)
    render(conn, "show.html", place: place)
  end

  def edit(conn, %{"id" => id}) do
    place = Places.get_place!(id)
    changeset = Places.change_place(place)
    render(conn, "edit.html", place: place, changeset: changeset)
  end

  def update(conn, %{"id" => id, "place" => place_params}) do
    place = Places.get_place!(id)

    case Places.update_place(place, place_params) do
      {:ok, place} ->
        conn
        |> put_flash(:info, "Place updated successfully.")
        |> redirect(to: Routes.admin_place_path(conn, :show, place))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", place: place, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    place = Places.get_place!(id)
    {:ok, _place} = Places.delete_place(place)

    conn
    |> put_flash(:info, "Place deleted successfully.")
    |> redirect(to: Routes.admin_place_path(conn, :index))
  end
end
