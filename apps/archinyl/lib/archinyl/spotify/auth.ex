defmodule Archinyl.Spotify.Auth do
  use HTTPoison.Base

  def get_access_token do
    config = Application.get_env(:archinyl, __MODULE__)

    basic_auth = Base.encode64("#{config[:client_id]}:#{config[:client_secret]}")

    request = %HTTPoison.Request{
      url: "https://accounts.spotify.com/api/token",
      method: :post,
      headers: [
        {"Content-Type", "application/x-www-form-urlencoded"},
        {"Authorization", "Basic #{basic_auth}"}
      ],
      body: {:form, [{:grant_type, "client_credentials"}]}
    }

    with {:ok, %HTTPoison.Response{body: body}} <- request(request),
         {:ok, data} <- Jason.decode(body) do
      data["access_token"]
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
