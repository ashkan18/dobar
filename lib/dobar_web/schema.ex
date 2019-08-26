defmodule DobarWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types(DobarWeb.Schema.JSON)
  import_types(DobarWeb.Schema.LocationType)
  import_types(DobarWeb.Schema.PlaceTypes)
  import_types(DobarWeb.Schema.AccountTypes)
  import_types(DobarWeb.Schema.ReviewTypes)
  import_types(DobarWeb.Schema.SocialTypes)

  alias DobarWeb.Resolvers

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Place, Dobar.Places.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  connection(node_type: :place)

  query do
    @desc "Find Places by location"
    connection field :places, node_type: :place do
      arg(:location, :location_input)
      arg(:term, :string)
      resolve(&Resolvers.PlaceResolver.find_places/3)
    end

    @desc "Find Place by Id"
    field :place, :place do
      arg(:id, non_null(:string))
      resolve(&Resolvers.PlaceResolver.find_place/3)
    end

    @desc "My user info"
    field :me, :user do
      resolve(&Resolvers.AccountResolver.current_user/3)
    end
  end

  mutation do
    @desc "Signup for an account"
    field :signup, type: :session do
      arg(:name, non_null(:string))
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))

      resolve(&Resolvers.AccountResolver.create/2)
    end

    @desc "Login"
    field :login, type: :session do
      arg(:username, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.AccountResolver.login/2)
    end

    @desc "Add to user's list"
    field :add_to_list, type: :user_list do
      arg(:place_id, non_null(:id))
      arg(:list_type, non_null(:string))

      resolve(&Resolvers.AccountResolver.add_to_list/3)
    end

    @desc "Invite people"
    field :invite_to_place, type: list_of(:place_invite) do
      arg(:place_id, non_null(:id))
      arg(:guest_emails, non_null(list_of(:string)))

      resolve(&Resolvers.SocialResolver.invite_to_place/3)
    end

    @desc "would you dobar"
    field :dobar, type: :review do
      arg(:place_id, non_null(:id))
      arg(:response, non_null(:boolean))

      resolve(&Resolvers.ReviewResolver.dobar/3)
    end

    @desc "Would your rideshare dobar"
    field :rideshare_dobar, type: :review do
      arg(:place_id, non_null(:id))
      arg(:response, non_null(:boolean))

      resolve(&Resolvers.ReviewResolver.rideshare_dobar/3)
    end
  end
end
