defmodule ArchinylWeb.RecordsLive do
  use ArchinylWeb, :live_view

  alias ArchinylWeb.Records.RecordTableLive

  @default_assigns [
    search_term: "",
    page_size: 15,
    page_number: 1
  ]

  @impl true
  def mount(_arg0, session, socket) do
    logged_in? = session["current_user"]

    socket =
      socket
      |> assign(logged_in?: logged_in?)
      |> assign(@default_assigns)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> set_search_term(params)
      |> set_page_term(params)

    Phoenix.PubSub.subscribe(Archinyl.PubSub, "records")

    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_record, record}, socket) do
    send_update(RecordTableLive, id: "records_table", new_record: record)
    {:noreply, socket}
  end

  def handle_info(:close_record_inforamtion_modal, socket) do
    send_update(RecordTableLive, id: "records_table", show_record_information: false)
    {:noreply, socket}
  end

  defp set_search_term(socket, params) do
    search_term = params["search"]
    assign(socket, search_term: search_term || "")
  end

  defp set_page_term(socket, params) do
    page = String.to_integer(params["page"] || "1")
    assign(socket, page_number: page)
  end
end
