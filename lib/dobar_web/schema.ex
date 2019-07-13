defmodule DobarWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types DobarWeb.Schema.JSON
  import_types DobarWeb.Schema.LocationType
  import_types DobarWeb.Schema.PlaceTypes
  import_types(DobarWeb.Schema.AccountTypes)

  alias DobarWeb.Resolvers

  connection(node_type: :place)

  query do
    @desc "Find Places Instance by location"
    connection field :places, node_type: :place do
      arg :lat, non_null(:float)
      arg :lng, non_null(:float)
      resolve &Resolvers.PlaceResolver.find_places/3
    end
  end

  mutation do
    @desc "SignUp for an account"
    field :create_user, type: :session do
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
  end
end