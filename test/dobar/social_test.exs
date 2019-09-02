defmodule Dobar.SocialTest do
  use Dobar.DataCase

  alias Dobar.Social

  describe "place_invite" do
    alias Dobar.Social.PlaceInvite
    alias Dobar.Fixtures

    @valid_attrs %{guest_email: "some guest_email", status: "pending"}
    @update_attrs %{guest_email: "some updated guest_email", status: "done"}
    @invalid_attrs %{guest_email: nil, status: nil}

    def place_invite_fixture(attrs \\ %{}) do
      user = Fixtures.create(:user)
      place = Fixtures.create(:place)

      {:ok, place_invite} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{place_id: place.id, host_id: user.id})
        |> Social.create_place_invite()

      place_invite
    end

    test "list_place_invite/0 returns all place_invite" do
      place_invite = place_invite_fixture()
      assert Social.list_place_invite() == [place_invite]
    end

    test "get_place_invite!/1 returns the place_invite with given id" do
      place_invite = place_invite_fixture()
      assert Social.get_place_invite!(place_invite.id) == place_invite
    end

    test "create_place_invite/1 with valid data creates a place_invite" do
      user = Fixtures.create(:user)
      place = Fixtures.create(:place)

      assert {:ok, %PlaceInvite{} = place_invite} =
               @valid_attrs
               |> Enum.into(%{place_id: place.id, host_id: user.id})
               |> Social.create_place_invite()

      assert place_invite.guest_email == "some guest_email"
      assert place_invite.status == "pending"
      assert place_invite.place_id == place.id
    end

    test "create_place_invite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_place_invite(@invalid_attrs)
    end

    test "create_place_invites/1 with valid data creates a place_invite" do
      user = Fixtures.create(:user)
      place = Fixtures.create(:place)
      emails = ["a@shkan.com", "ash@kan.com"]

      assert {:ok, invites} =
               Social.create_place_invites(%{
                 place_id: place.id,
                 host_id: user.id,
                 guest_emails: emails
               })

      assert Enum.map(invites, fn i -> i.place_id end) == [place.id, place.id]
      assert Enum.map(invites, fn i -> i.guest_email end) == emails
    end

    test "update_place_invite/2 with valid data updates the place_invite" do
      place_invite = place_invite_fixture()

      assert {:ok, %PlaceInvite{} = place_invite} =
               Social.update_place_invite(place_invite, @update_attrs)

      assert place_invite.guest_email == "some updated guest_email"
      assert place_invite.status == "done"
    end

    test "update_place_invite/2 with invalid data returns error changeset" do
      place_invite = place_invite_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Social.update_place_invite(place_invite, @invalid_attrs)

      assert place_invite == Social.get_place_invite!(place_invite.id)
    end

    test "delete_place_invite/1 deletes the place_invite" do
      place_invite = place_invite_fixture()
      assert {:ok, %PlaceInvite{}} = Social.delete_place_invite(place_invite)
      assert_raise Ecto.NoResultsError, fn -> Social.get_place_invite!(place_invite.id) end
    end

    test "change_place_invite/1 returns a place_invite changeset" do
      place_invite = place_invite_fixture()
      assert %Ecto.Changeset{} = Social.change_place_invite(place_invite)
    end
  end
end
