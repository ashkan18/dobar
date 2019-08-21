defmodule Dobar.AccountsTest do
  use Dobar.DataCase

  alias Dobar.Accounts
  alias Dobar.Fixtures

  describe "users" do
    alias Dobar.Accounts.User

    @valid_attrs %{
      email: "test@dobar.com",
      name: "some name",
      password: "some password",
      username: "some username"
    }

    @update_attrs %{
      email: "test2@dobar.com",
      name: "some updated name",
      password: "some updated password",
      username: "some updated username"
    }
    @invalid_attrs %{email: nil, name: nil, password: nil, username: nil}

    test "list_users/0 returns all users" do
      user = Fixtures.create(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = Fixtures.create(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@dobar.com"
      assert user.name == "some name"
      assert !is_nil(user.password)
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = Fixtures.create(:user)
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "test2@dobar.com"
      assert user.name == "some updated name"
      assert is_nil(user.password) == false
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = Fixtures.create(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = Fixtures.create(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = Fixtures.create(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "user_lists" do
    alias Dobar.Accounts.UserList

    @valid_attrs %{list_type: "planning_to_go"}
    @update_attrs %{list_type: "check_later"}
    @invalid_attrs %{list_type: nil}

    def user_list_fixture(attrs \\ %{}) do
      user = Fixtures.create(:user)
      place = Fixtures.create(:place)

      {:ok, user_list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{place_id: place.id, user_id: user.id})
        |> Accounts.create_user_list()

      user_list
    end

    test "list_user_lists/0 returns all user_lists" do
      user_list = user_list_fixture()
      assert Accounts.list_user_lists() == [user_list]
    end

    test "get_user_list!/1 returns the user_list with given id" do
      user_list = user_list_fixture()
      assert Accounts.get_user_list!(user_list.id) == user_list
    end

    test "create_user_list/1 with valid data creates a user_list" do
      user = Fixtures.create(:user)
      place = Fixtures.create(:place)

      assert {:ok, %UserList{} = user_list} =
               @valid_attrs
               |> Enum.into(%{place_id: place.id, user_id: user.id})
               |> Accounts.create_user_list()

      assert user_list.list_type == "planning_to_go"
      assert user_list.user_id == user.id
      assert user_list.place_id == place.id
    end

    test "create_user_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_list(@invalid_attrs)
    end

    test "update_user_list/2 with valid data updates the user_list" do
      user_list = user_list_fixture()
      assert {:ok, %UserList{} = user_list} = Accounts.update_user_list(user_list, @update_attrs)
      assert user_list.list_type == "check_later"
    end

    test "update_user_list/2 with invalid data returns error changeset" do
      user_list = user_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_list(user_list, @invalid_attrs)
      assert user_list == Accounts.get_user_list!(user_list.id)
    end

    test "delete_user_list/1 deletes the user_list" do
      user_list = user_list_fixture()
      assert {:ok, %UserList{}} = Accounts.delete_user_list(user_list)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_list!(user_list.id) end
    end

    test "change_user_list/1 returns a user_list changeset" do
      user_list = user_list_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_list(user_list)
    end
  end
end
