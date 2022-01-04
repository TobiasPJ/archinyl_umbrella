defmodule Archinyl.LastFM.Request do
  def get_artist_desc(artist) do
    base_request("", :get, %{method: "artist.getinfo", artist: artist})
  end

  defp base_request(endpoint, method, params) do
    config = Application.get_env(:archinyl, __MODULE__)

    params = Map.merge(params, %{api_key: config[:api_key], format: "json"})

    %HTTPoison.Request{
      url: "http://ws.audioscrobbler.com/2.0/" <> endpoint,
      method: method,
      headers: [
        {"Accept", "*/*"}
      ],
      params: params
    }
  end
end
