defmodule Dobar.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :username, :string
    field :roles, {:array, :string}, default: []

    has_many :reviews, Dobar.Reviews.Review
    has_many :lists, Dobar.Accounts.UserList
    has_many :invites, Dobar.Social.PlaceInvite, foreign_key: :host_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :username, :password, :roles])
    |> validate_required([:email, :name, :username, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:username, name: :users_username_uniq_idx)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
