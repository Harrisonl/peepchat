defmodule Peepchat.User do
  use Peepchat.Web, :model

  schema "users" do
    field :email, :string
    field :password_hash, :string

    field :password_confirmation, :string, virtual: true
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email password password_confirmation)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password
    |> unique_constraint(:email)
  end

  # Check if the passwords valid before hashing it
  def hash_password(%{valid?: false} = changeset), do: changeset
  def hash_password(%{valid?: true} = changeset) do
    hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashedpw)
  end
end
