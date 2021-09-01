defmodule Archinyl do
  import Bcrypt.Base
  alias Archinyl.Schema.User

  @salt "$2b$12$4BJUL0QXzfg2U/7n5j2ZPO"

  def register_user(%User{
        full_name: full_name,
        username: username,
        email: email,
        password: password
      }) do

    password = hash_password(password, @salt)

    Archinyl.Repo.insert_user(%User{
      full_name: full_name,
      username: username,
      email: email,
      password: password
    })
  end

  def login(email, password) do

    case Archinyl.Repo.get_user(email) do
      nil -> {:error, "No user with given email"}

      %User{id: id, password: user_password} ->
        password = hash_password(password, @salt)

        case user_password do
          ^password -> {:ok, id}
          _ -> {:error, "Wrong password"}
        end
    end

  end
end
