defmodule DobarWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  connection(node_type: :user_list)

  @desc "A User"
  object :user do
    field :id, :string
    field :name, :string

    connection field :lists, node_type: :user_list do
      resolve(fn
        pagination_args, %{source: user} ->
          user = Dobar.Repo.preload(user, :lists)
          Absinthe.Relay.Connection.from_list(user.lists, pagination_args)
      end)
    end
  end

  @desc "A Session"
  object :session do
    field :token, :string
  end

  @desc "A user list type"
  object :user_list do
    field :id, :string
    field :user, :user
    field :place, :place, resolve: dataloader(Place)
    field :list_type, :string
  end
end
