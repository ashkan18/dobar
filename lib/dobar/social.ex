defmodule Dobar.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias Dobar.Repo

  alias Dobar.Social.PlaceInvite

  @doc """
  Returns the list of place_invite.

  ## Examples

      iex> list_place_invite()
      [%PlaceInvite{}, ...]

  """
  def list_place_invite do
    Repo.all(PlaceInvite)
  end

  @doc """
  Gets a single place_invite.

  Raises `Ecto.NoResultsError` if the Place invite does not exist.

  ## Examples

      iex> get_place_invite!(123)
      %PlaceInvite{}

      iex> get_place_invite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_place_invite!(id), do: Repo.get!(PlaceInvite, id)

  @doc """
  Creates a place_invite.

  ## Examples

      iex> create_place_invite(%{field: value})
      {:ok, %PlaceInvite{}}

      iex> create_place_invite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_place_invite(attrs \\ %{}) do
    %PlaceInvite{}
    |> PlaceInvite.changeset(attrs)
    |> Repo.insert()
  end

  def create_place_invites(%{place_id: place_id, host_id: host_id, guest_emails: guest_emails}) when is_list(guest_emails) do
    invites = guest_emails
    |> Enum.uniq()
    |> Enum.map(&create_place_invite(%{place_id: place_id, host_id: host_id, guest_email: &1}))
    |> Enum.map(&Kernel.elem(&1, 1))
    {:ok, invites}
  end

  def create_place_invites(_), do: {:error, "invalid input"}
  @doc """
  Updates a place_invite.

  ## Examples

      iex> update_place_invite(place_invite, %{field: new_value})
      {:ok, %PlaceInvite{}}

      iex> update_place_invite(place_invite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_place_invite(%PlaceInvite{} = place_invite, attrs) do
    place_invite
    |> PlaceInvite.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PlaceInvite.

  ## Examples

      iex> delete_place_invite(place_invite)
      {:ok, %PlaceInvite{}}

      iex> delete_place_invite(place_invite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_place_invite(%PlaceInvite{} = place_invite) do
    Repo.delete(place_invite)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking place_invite changes.

  ## Examples

      iex> change_place_invite(place_invite)
      %Ecto.Changeset{source: %PlaceInvite{}}

  """
  def change_place_invite(%PlaceInvite{} = place_invite) do
    PlaceInvite.changeset(place_invite, %{})
  end
end