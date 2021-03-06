defmodule Peepchat.RegistrationController do
  use Peepchat.Web, :controller
  alias Peepchat.User


  def create(conn, %{"data" => %{"type" => "user", "attributes" => 
     %{"email" => email, 
      "password" => password, 
      "password_confirmation" => password_confirmation}}}) do
    changeset = User.changeset(%User{}, %{email: email, password: password, password_confirmation: password_confirmation})

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Peepchat.UserView, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Peepchat.ChangesetView, "error.json", changeset: changeset) #have a single error page for changesets
    end
  end
end
