defmodule DobarWeb.Resolvers.DiscoverResolver do
  alias Dobar.{Discover, Accounts}

  def find_us_new_places(
        _parent,
        args = %{other_usernames: other_usernames, being_adventurous: being_adventurous},
        %{
          context: %{current_user: current_user}
        }
      )
      when not is_nil(current_user) do
    other_usernames
    |> Accounts.find_users_by_username()
    |> Enum.reduce([current_user.id], fn a, acc -> acc ++ [a.id] end)
    |> Discover.find_users_a_new_place(being_adventurous)
    |> Absinthe.Relay.Connection.from_list(args)
  end

  def find_us_new_places(_parent, _args, _context), do: {:error, "Not Authorized"}
end
