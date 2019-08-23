defmodule DobarWeb.Schema.SocialTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "An invitation to a place"
  object :place_invite do
    field :id, :string
    field :guest, :user
    field :place, :place, resolve: dataloader(Place)
    field :email, :string
    field :status, :string
  end
end
