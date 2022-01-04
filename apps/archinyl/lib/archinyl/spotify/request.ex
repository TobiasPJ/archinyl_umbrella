defmodule Archinyl.Spotify.Request do
  def search(query, type) do
    base_request("/search", :get, %{type: type, q: query})
  end

  def get_album(album_id) do
    base_request("/albums/#{album_id}", :get)
  end

  defp base_request(endpoint, method, params \\ %{}) do
    access_token = Archinyl.Spotify.Auth.get_access_token()

    %HTTPoison.Request{
      url: "https://api.spotify.com/v1" <> endpoint,
      method: method,
      headers: [
        {"Accept", "*/*"},
        {"Authorization", "Bearer #{access_token}"}
      ],
      params: params
    }
  end
end
