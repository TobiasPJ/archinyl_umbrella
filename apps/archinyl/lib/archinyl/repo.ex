defmodule Archinyl.Repo do
  use Ecto.Repo,
    otp_app: :archinyl,
    adapter: Ecto.Adapters.Postgres

  alias Archinyl.Schema.User

  def insert_user(user) do
    %User{
      full_name: full_name,
      username: username,
      email: email,
      password: password
    } = user

    user = %User{}
    params = %{full_name: full_name, username: username, email: email, password: password}

    user
    |> User.changeset(params)
    |> insert()
  end

  def get_user(email) do
    User
    |> get_by(email: email)
  end
end
