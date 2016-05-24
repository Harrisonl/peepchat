defmodule Peepchat.Router do
  use Peepchat.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", Peepchat do
    pipe_through :api

    # user creation and authentication
    post "register", RegistrationController, :create
    post "token", SessionController, :create, as: :login

    resources "session", SessionController, only: [:index]
  end
end
