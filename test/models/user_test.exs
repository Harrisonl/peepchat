defmodule Peepchat.UserTest do
  use Peepchat.ModelCase

  alias Peepchat.User

  @valid_attrs %{email: "alice@test.com", password: "abcd1234", password_confirmation: "abcd1234"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password and password confirmation don't match" do 
    changeset = User.changeset(%User{}, %{email: "alice@test.com", password: "1234abcd", password_confirmation: "abcd1234"})
    refute changeset.valid?
  end

  test "missing the password confirmation won't save the user" do
    changeset = User.changeset(%User{}, %{email: "alice@test.com", password: "1234abcd"})
    refute changeset.valid?
  end

  test "short password won't work" do
    changeset = User.changeset(%User{}, %{email: "alice@test.com", password: "1234", password_confirmation: "1234"})
    refute changeset.valid?
  end
end
