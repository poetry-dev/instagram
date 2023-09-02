defmodule Instagram.Posts do
  alias Instagram.Repo
  alias Instagram.Posts.Post

  def save(post_params) do
    %Post{}
    |> Post.changeset(post_params)
    |> Repo.insert()
  end
end
