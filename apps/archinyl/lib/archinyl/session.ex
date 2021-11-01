defmodule Archinyl.Session do
  alias Archinyl.Schema.User

  def login(params) do
    user = Archinyl.Repo.get_by(User, email: String.downcase(params["email"]))

    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _ -> Bcrypt.verify_pass(password, user.password)
    end
  end
end
