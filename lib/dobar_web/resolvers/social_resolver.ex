defmodule DobarWeb.Resolvers.SocialResolver do
  alias Dobar.Social

  def invite_to_place(_parent, %{place_id: place_id, guest_emails: guest_emails}, %{
        context: %{current_user: %{id: user_id}}
      }) do
    Social.create_place_invites(%{
      place_id: place_id,
      host_id: user_id,
      guest_emails: guest_emails
    })
  end

  def invite_to_place(_parent, _args, _context), do: {:error, "Not Authorized"}
end
