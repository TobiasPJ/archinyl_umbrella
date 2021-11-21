defmodule ArchinylWeb.Records.RecordInformationModalLive do
  use ArchinylWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    record = assigns.record_id |> Archinyl.get_record()
    socket = assign(socket, record: record)
    {:ok, assign(socket, assigns)}
  end
end
