defmodule ArchinylWeb.User.UserInformationLive do
  use ArchinylWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> get_user()
      |> calc_account_age()

    {:ok, socket}
  end

  defp get_user(socket) do
    current_user = socket.assigns.logged_in?

    user = Archinyl.Repo.get_user(current_user)

    assign(socket, user: user)
  end

  defp calc_account_age(socket) do
    diff =
      socket.assigns.user.inserted_at
      |> NaiveDateTime.to_date()
      |> (&Date.diff(Date.utc_today(), &1)).()

    assign(socket, account_age: "#{diff} Days")
  end
end
