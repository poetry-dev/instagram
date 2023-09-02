defmodule Instagram.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Instagram.Accounts.User

  schema "posts" do
    field :caption, :string
    field :image_path, :string
    # field :user_id, :id
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:caption, :image_path, :user_id])
    |> validate_required([:caption, :image_path, :user_id])
  end
end
