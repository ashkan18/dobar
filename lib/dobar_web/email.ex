defmodule DobarWeb.Email do
  use Bamboo.Phoenix, view: DobarWeb.EmailView

  def place_invite(place_invite) do
    base_email()
    |> to(place_invite.guest_email)
    |> subject("You are invited to checkout a new place!")
    |> assign(:place_invite, place_invite)
    |> render(:place_invite)
  end

  defp base_email do
    new_email()
    |> from("No-Reply<invites@do-bar.com>")
    |> put_header("Reply-To", "invites@do-bar.com")
    # This will use the "email.html.eex" file as a layout when rendering html emails.
    # Plain text emails will not use a layout unless you use `put_text_layout`
    |> put_html_layout({DobarWeb.LayoutView, "email.html"})
  end
end
