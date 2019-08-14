defmodule Dobar.Accounts.UserList do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_lists" do
    field :list_type, :string
    field :user_id, :binary_id
    field :place_id, :binary_id

    timestamps()
  end

  @required_fields ~w(place_id user_id list_type)a
  @list_types ~w(planning_to_go check_later)

  @doc false
  def changeset(user_list, attrs) do
    user_list
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:list_type, @list_types)
    |> foreign_key_constraint(:place_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_listss_place_id_user_id_type_uniq, name: :user_listss_place_id_user_id_type_uniq_idx)
  end
end
