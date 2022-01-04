defmodule Archinyl.LastFM.Client do
  use HTTPoison.Base
  alias Archinyl.LastFM.Request

  def get_artist_desc(artist) do
    request = Request.get_artist_desc(artist)

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
