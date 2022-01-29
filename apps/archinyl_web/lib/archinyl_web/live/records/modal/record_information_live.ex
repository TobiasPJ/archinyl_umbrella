defmodule ArchinylWeb.Records.Modal.RecordInformationLive do
  use ArchinylWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
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

  defp close_modal(socket) do
    caller = socket.assigns.caller
    Process.send(caller, :close_record_inforamtion_modal, [:noconnect])
  end
end
