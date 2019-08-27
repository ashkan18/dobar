defmodule DobarWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  connection(node_type: :user_list)
  connection(node_type: :place_invite)

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
    connection field :invitations, node_type: :place_invite do
      resolve(fn
        pagination_args, %{source: user} ->
          invitations = Dobar.Social.invites_by_email(user.email)
          Absinthe.Relay.Connection.from_list(invitations, pagination_args)
      end)
    end
    connection field :invites, node_type: :place_invite do
      resolve(fn
        pagination_args, %{source: user} ->
          user = Dobar.Repo.preload(user, :invites)
          Absinthe.Relay.Connection.from_list(user.invites, pagination_args)
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
    field :user, :user, resolve: dataloader(User)
    field :place, :place, resolve: dataloader(Place)
    field :list_type, :string
  end
end
