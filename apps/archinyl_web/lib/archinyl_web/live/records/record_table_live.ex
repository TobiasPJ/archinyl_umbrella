defmodule ArchinylWeb.Records.RecordTableLive do
  use ArchinylWeb, :live_component

  @default_assigns [
    records: [],
    add_record_modal: false,
    show_record_information: false,
    add_to_collection_modal: false,
    search_term: "",
    page_size: 15,
    page_number: 1,
    number_of_pages: 0,
    total_count: 0
  ]

  @impl true

  def mount(socket) do
    socket =
      socket
      |> assign(@default_assigns)
      |> assign(self: self())
      |> get_records()
      |> calc_total_runtime()

    {:ok, socket}
  end

  @impl true
  def update(%{show_record_information: val}, socket) do
    {:ok, assign(socket, record: %{}, show_record_information: val)}
  end

  def update(%{new_record: _record}, socket) do
    socket =
      socket
      |> get_records()
      |> calc_total_runtime()

    {:ok, socket}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> get_records()
      |> calc_total_runtime()

    {:ok, socket}
  end

  @impl true
  def handle_event("open_add_record_modal", _params, socket) do
    {:noreply, assign(socket, add_record_modal: true)}
  end

  def handle_event("close_add_record_modal", _params, socket) do
    {:noreply, assign(socket, add_record_modal: false)}
  end

  def handle_event("show_record_information", %{"record_id" => record_id}, socket) do
    record = find_record(socket, record_id)
    {:noreply, assign(socket, show_record_information: true, record: record)}
  end

  def handle_event("search_records", %{"search_term" => search_term}, socket) do
    set_params(assign(socket, search_term: search_term))
  end

  def handle_event("open_add_to_collection_modal", %{"value" => record_id}, socket) do
    record = find_record(socket, record_id)
    {:noreply, assign(socket, add_to_collection_modal: true, record_to_add: record)}
  end

  def handle_event("close_add_to_collection_modal", _params, socket) do
    {:noreply, assign(socket, add_to_collection_modal: false, record_to_add: nil)}
  end

  def handle_event("next_page", _params, socket) do
    number_of_pages = socket.assigns[:number_of_pages]
    page_number = socket.assigns[:page_number]

    if page_number == number_of_pages do
      {:noreply, socket}
    else
      set_params(assign(socket, page_number: page_number + 1))
    end
  end

  def handle_event("previous_page", _params, socket) do
    page_number = socket.assigns[:page_number]

    if page_number == 1 do
      {:noreply, socket}
    else
      set_params(assign(socket, page_number: page_number - 1))
    end
  end

  defp set_params(socket) do
    %{
      assigns: %{
        search_term: search_term,
        page_number: page_number
      }
    } = socket

    {:noreply,
     push_patch(socket,
       to: Routes.records_path(socket, :record, search: search_term, page: page_number)
     )}
  end

  defp get_records(socket) do
    %{
      assigns: %{
        search_term: search_term,
        page_size: limit,
        page_number: page_number
      }
    } = socket

    offset = (page_number - 1) * limit

    %{records: records, total_count: total_count} =
      Archinyl.get_records(search_term, limit, offset)

    assign(socket,
      records: records,
      total_count: total_count,
      number_of_pages: ceil(total_count / limit)
    )
  end

  defp find_record(socket, record_id) do
    record_id = String.to_integer(record_id)
    Enum.find(socket.assigns[:records], %{}, &(&1.id == record_id))
  end

  defp calc_total_runtime(socket) do
    records = socket.assigns[:records]

    records =
      Enum.map(records, fn record ->
        songs = record.songs

        total_runtime =
          Enum.reduce(songs, 0, fn song, acc ->
            {s, _ms} = Time.to_seconds_after_midnight(song.runtime)
            acc + s
          end)

        Map.put(record, :total_runtime, total_runtime)
      end)

    assign(socket, records: records)
  end
end
