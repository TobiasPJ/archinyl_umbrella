defmodule Archinyl.Spotify.Client do
  use HTTPoison.Base

  alias Archinyl.Spotify.Request

  def search(query, type) do
    request = Request.search(query, type)

    basic_client(request)
  end

  def get_album(album_id) do
    request = Request.get_album(album_id)

    basic_client(request)
  end

  defp basic_client(request) do
    with {:ok, %HTTPoison.Response{body: body}} <- request(request),
         {:ok, data} <- Jason.decode(body) do
      {:ok, data}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
