defmodule Dobar.Discover do
  import Ecto.Query, warn: false

  alias Dobar.{Repo, Places.Place, Reviews.Review}

  def find_users_a_new_place(user_ids, be_adventorus \\ false) do
    # finds a new place for people with these ids based on their favorites and list of places they've been/invited
    # be_adventorus decides if we should take them to new type of place or not
    reviewed_places =
      from(r in Review,
        where: r.user_id in ^user_ids,
        join: p in assoc(r, :place),
        select: [r.place_id, p.tags, p.location],
        distinct: true
      )
      |> Repo.all()

    reviewd_place_ids = Enum.map(reviewed_places, &Enum.at(&1, 0))
    tags = Enum.flat_map(reviewed_places, &Enum.at(&1, 1))

    Place
    |> filter_places(reviewd_place_ids)
    |> tune_adventorusness(tags, be_adventorus)
    |> limit(10)
    |> Repo.all()
  end

  defp filter_places(query, place_ids) do
    from p in query,
      where: p.id not in ^place_ids
  end

  defp tune_adventorusness(query, tags, true) do
    from p in query,
      where: fragment("not(? && ?)", p.tags, ^tags)
  end

  defp tune_adventorusness(query, tags, false) do
    from p in query,
      where: fragment("? && ?", p.tags, ^tags)
  end
end
