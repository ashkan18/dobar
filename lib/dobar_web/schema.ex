defmodule ReadtomeWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias ReadtomeWeb.Resolvers


  query do
    @desc "Find Book Instance by location"
    field :book_instances, list_of(:book_instance) do
      arg :lat, non_null(:float)
      arg :lng, non_null(:float)
      arg :term, :string
      arg :offerings, list_of(:string)
      resolve &Resolvers.Book.find_book_instances/3
    end
  end
end