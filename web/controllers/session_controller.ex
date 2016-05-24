defmodule Peepchat.SessionController do
  use Peepchat.Web, :controller
  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt

  alias Peepchat.User


  def create(conn, %{"grant_type" => "password", "username" => email, "password" => password}) do
    case Repo.get_by(User, %{email: email}) do
      nil ->
        Comeonin.Bcrypt.dummy_checkpw
        login_failed(conn)
      user ->
        if Comeonin.Bcrypt.checkpw(password, user.password_hash) do
          {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
          conn
          |> json(%{access_token: jwt})
        else
          login_failed(conn)
        end
    end
  end

  def create(conn, %{"grant_type" => _}) do
    throw "Unsupported grant_type"
  end

  def login_failed(conn) do
    conn
    |> put_status(401)
    |> render(Peepchat.ErrorView, "401.json")
  end
end
