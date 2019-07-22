defmodule DobarWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types(DobarWeb.Schema.JSON)
  import_types(DobarWeb.Schema.LocationType)
  import_types(DobarWeb.Schema.PlaceTypes)
  import_types(DobarWeb.Schema.AccountTypes)

  alias DobarWeb.Resolvers

  connection(node_type: :place)

  query do
    @desc "Find Places by location"
    connection field :places, node_type: :place do
      arg(:location, :location_input)
      resolve(&Resolvers.PlaceResolver.find_places/3)
    end

    @desc "My user info"
    field :me, :user do
      resolve(&Resolvers.UserResolver.current_user/3)
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

      resolve(&Resolvers.UserResolver.create/2)
    end

    @desc "Login"
    field :login, type: :session do
      arg(:username, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.UserResolver.login/2)
    end

    @desc "Dobar?"
    field :dobar, type: :boolean do
      arg(:place_id, non_null(:id))
      arg(:response, non_null(:boolean))

      resolve(&Resolvers.ReviewResolver.dobar/3)
    end

    @desc "Rideshare Dobar?"
    field :rideshare_dobar, type: :boolean do
      arg(:place_id, non_null(:id))
      arg(:response, non_null(:boolean))

      resolve(&Resolvers.ReviewResolver.rideshare_dobar/3)
    end
  end
end
