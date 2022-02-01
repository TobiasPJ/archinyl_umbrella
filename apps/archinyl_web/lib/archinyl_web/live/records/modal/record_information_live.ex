defmodule ArchinylWeb.Records.Modal.RecordInformationLive do
  use ArchinylWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    %{
      logged_in?: user_id,
      record: %{
        id: record_id
      }
    } = assigns

    liked =
      if user_id do
        Archinyl.Repo.check_if_liked(user_id, record_id)
      else
        false
      end

    total_likes = Archinyl.Repo.count_likes(record_id)

    socket = socket |> assign(assigns) |> assign(liked: liked) |> assign(total_likes: total_likes)

    {:ok, socket}
  end

  @impl true
  def handle_event("call_close_record_information", _params, socket) do
    close_modal(socket)

    {:noreply, socket}
  end

  def handle_event("escape_keyup", %{"key" => "Escape"}, socket) do
    close_modal(socket)

    {:noreply, socket}
  end

  def handle_event("escape_keyup", _, socket) do
    {:noreply, socket}
  end

  def handle_event("like_record", params, socket) do
    %{
      logged_in?: user_id,
      total_likes: total_likes,
      record: %{
        id: record_id
      }
    } = socket.assigns

    case params do
      %{"value" => "on"} ->
        Archinyl.Repo.like_record(user_id, record_id)
        {:noreply, assign(socket, liked: true, total_likes: total_likes + 1)}

      _ ->
        Archinyl.Repo.unlike_record(user_id, record_id)
        {:noreply, assign(socket, liked: false, total_likes: total_likes - 1)}
    end
  end

  defp close_modal(socket) do
    caller = socket.assigns.caller
    Process.send(caller, :close_record_inforamtion_modal, [:noconnect])
  end
end
