defmodule Dobar.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Dobar.Repo

  alias Dobar.Accounts.User
  alias Comeonin.Bcrypt

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate_user(username, given_password) do
    with user when not is_nil(user) <- Repo.get_by(User, username: username) do
      check_password(user, given_password)
    else
      _ -> {:error, "Invalid User or Password"}
    end
  end

  defp check_password(nil, _), do: {:error, "Incorrect username or password"}

  defp check_password(user, given_password) do
    case Bcrypt.checkpw(given_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end

  alias Dobar.Accounts.UserList

  @doc """
  Returns the list of user_lists.

  ## Examples

      iex> list_user_lists()
      [%UserList{}, ...]

  """
  def list_user_lists do
    Repo.all(UserList)
  end

  @doc """
  Gets a single user_list.

  Raises `Ecto.NoResultsError` if the User list does not exist.

  ## Examples

      iex> get_user_list!(123)
      %UserList{}

      iex> get_user_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_list!(id), do: Repo.get!(UserList, id)

  @doc """
  Creates a user_list.

  ## Examples

      iex> create_user_list(%{field: value})
      {:ok, %UserList{}}

      iex> create_user_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_list(attrs \\ %{}) do
    %UserList{}
    |> UserList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_list.

  ## Examples

      iex> update_user_list(user_list, %{field: new_value})
      {:ok, %UserList{}}

      iex> update_user_list(user_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_list(%UserList{} = user_list, attrs) do
    user_list
    |> UserList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserList.

  ## Examples

      iex> delete_user_list(user_list)
      {:ok, %UserList{}}

      iex> delete_user_list(user_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_list(%UserList{} = user_list) do
    Repo.delete(user_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_list changes.

  ## Examples

      iex> change_user_list(user_list)
      %Ecto.Changeset{source: %UserList{}}

  """
  def change_user_list(%UserList{} = user_list) do
    UserList.changeset(user_list, %{})
  end

  def user_place_list(user_id, place_id) do
    UserList
    |> where([r], r.place_id == ^place_id)
    |> where([r], r.user_id == ^user_id)
    |> Repo.all()
  end

  def find_users_by_username(usernames) when is_list(usernames) do
    from(u in User,
      where: u.username in ^usernames
    )
    |> Repo.all()
  end

  def find_users_by_username(usernames) when is_binary(usernames) do
    from(u in User,
      where: u.username == ^usernames
    )
    |> Repo.all()
  end

  def data() do
    Dataloader.Ecto.new(Repo)
  end
end
