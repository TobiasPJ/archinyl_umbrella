defmodule ArchinylWeb.Components.Pagination do
  use Phoenix.Component

  alias Phoenix.HTML.Tag

  @doc """
  To use this the liveview has to implement a next_page and a previous_page function
  """
  def pagination(assigns) do
    ~H"""
    <nav class="pagination is-rounded" role="navigation">
      <%=Tag.content_tag(:a, class: "pagination-previous", phx_click: "previous_page", phx_target: @target, disabled: @page_number == 1) do %>
      <i class="fas fa-arrow-left"></i>
      <%end%>
      <%=Tag.content_tag(:a, class: "pagination-next", phx_click: "next_page", phx_target: @target, disabled:  @page_number == @number_of_pages || @number_of_pages == 0)  do %>
      <i class="fas fa-arrow-right"></i>
      <%end%>
      <ul class="pagination-list">
          <li>
              <%=Tag.content_tag(:a, class: if(@page_number== 1, do: "pagination-link is-current", else: "pagination-link")) do%>
              1
              <%end %>
          </li>
          <%=if @page_number != 1 && @page_number != @number_of_pages do%>
          <li>
              <span class="pagination-ellipsis">&hellip;</span>
          </li>
          <li>
            <%=Tag.content_tag(:a, class: "pagination-link is-current") do @page_number end%>
          </li>
          <li>
              <span class="pagination-ellipsis">&hellip;</span>
          </li>
          <%end%>
          <%=if @number_of_pages > 1 do%>
          <li>
              <%=Tag.content_tag(:a, class: if(@page_number == @number_of_pages, do: "pagination-link is-current", else: "pagination-link")) do%>
              <%=@number_of_pages%>
              <%end %>
          </li>
          <%end%>
          <li>
              <span style="margin-left: 10px">
                  <%="Totalt #{@total_count} " <> case @total_count, do: (1 -> @type_singular; _ -> @type_plural)%>
              </span>
          </li>
      </ul>
    </nav>
    """
  end
end
