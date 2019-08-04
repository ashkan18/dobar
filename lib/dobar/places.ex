defmodule Dobar.Places do
  @moduledoc """
  The Places context.
  """

  import Ecto.Query, warn: false
  import Geo.PostGIS

  alias Dobar.Repo

  alias Dobar.Places.Place

  @doc """
  Returns the list of places.

  ## Examples

      iex> find_places()
      [%Place{}, ...]

  """
  def find_places(args \\ %{}) do
    Place
    |> filter_query(args)
    |> Repo.all()
  end

  defp filter_query(query, args), do: Enum.reduce(args, query, &place_query/2)

  defp place_query({:location, %{lat: lat, lng: lng}}, query) do
    point = %Geo.Point{coordinates: {lat, lng}, srid: 4326}

    from place in query,
      order_by: st_distance(place.location, ^point)
  end

  defp place_query({:term, term}, query) do
    from place in query,
      where: place.name == ^term
  end

  defp place_query(_, query), do: query

  @doc """
  Gets a single place.

  Raises `Ecto.NoResultsError` if the Place does not exist.

  ## Examples

      iex> get_place!(123)
      %Place{}

      iex> get_place!(456)
      ** (Ecto.NoResultsError)

  """
  def get_place!(id), do: Repo.get!(Place, id)

  @doc """
  Creates a place.

  ## Examples

      iex> create_place(%{field: value})
      {:ok, %Place{}}

      iex> create_place(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_place(atts \\ %{})

  def create_place(attrs = %{"lat" => lat, "lng" => lng}) do
    location = %Geo.Point{coordinates: {lat, lng}, srid: 4326}

    attrs
    |> Map.drop(["lat", "lng"])
    |> Map.put("location", location)
    |> create_place()
  end

  def create_place(attrs) do
    %Place{}
    |> Place.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a place.

  ## Examples

      iex> update_place(place, %{field: new_value})
      {:ok, %Place{}}

      iex> update_place(place, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_place(%Place{} = place, attrs) do
    place
    |> Place.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Place.

  ## Examples

      iex> delete_place(place)
      {:ok, %Place{}}

      iex> delete_place(place)
      {:error, %Ecto.Changeset{}}

  """
  def delete_place(%Place{} = place) do
    Repo.delete(place)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking place changes.

  ## Examples

      iex> change_place(place)
      %Ecto.Changeset{source: %Place{}}

  """
  def change_place(%Place{} = place) do
    Place.changeset(place, %{})
  end
end
