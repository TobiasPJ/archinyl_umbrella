defmodule Archinyl.Registration do
  import Ecto.Changeset, only: [put_change: 3]

  alias Archinyl.Schema.Library

  def create(changeset, repo) do
    {:ok, user} =
      changeset
      |> put_change(:password, hashed_password(changeset.params["noenc_password"]))
      |> repo.insert()

    Archinyl.Repo.insert_library(%Library{user_id: user.id})
    {:ok, user}
  end

  defp hashed_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end
end
