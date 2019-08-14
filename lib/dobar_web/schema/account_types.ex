defmodule DobarWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  @desc "A User"
  object :user do
    field :id, :string
    field :name, :string
  end

  @desc "A Session"
  object :session do
    field :token, :string
  end

  @desc "A user list type"
  object :user_list do
    field :id, :string
    field :user, :user
    field :place, :place
    field :list_type, :string
  end
end
