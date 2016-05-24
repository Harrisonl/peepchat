defmodule Peepchat.RegistrationControllerTest do
  use Peepchat.ConnCase
  alias Peepchat.User

  @valid_attrs %{
    email: "alice@test.com",
    password: "1234abcd",
    password_confirmation: "1234abcd"
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")} # Setup the request
  end

  test "creates and renders a new user when there is valid data", %{conn: conn} do
    conn = post conn, registration_path(conn, :create) ,%{data: %{type: "user", attributes: @valid_attrs}} # Creates the JSON-API format of a create request
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, %{email: @valid_attrs[:email]})
  end

  test "does not create a user and returns errors when invalid data is sent" do
    assert_error_sent 400, fn ->
      conn = post conn, registration_path(conn, :create) ,%{data: %{type: "user", attributes: @invalid_attrs}} 
    end
  end

end
