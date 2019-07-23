defmodule DobarWeb.Schema.ReviewTypes do
  use Absinthe.Schema.Notation

  @desc "A User Review"
  object :review do
    field :id, :string
    field :review_type, :string
    field :response, :boolean
    field :place, :place
    field :user, :user
  end
end
