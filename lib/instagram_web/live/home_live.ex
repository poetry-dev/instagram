defmodule InstagramWeb.HomeLive do
  use InstagramWeb, :live_view

  alias Instagram.Posts
  alias Instagram.Posts.Post

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-2xl">Instagram</h1>
      <.button type="button" phx-click={show_modal("new-post-modal")}>发帖</.button>

    <.modal id="new-post-modal">
      <.simple_form for={@form} phx-change="validate" phx-submit="save-post">
        <.live_file_input upload={@uploads.image} required />
        <.input field={@form[:caption]} type="textarea" label="Caption" required />

        <.button type="submit" phx-disable-with="Saving ...">发帖</.button>
      </.simple_form>
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    form =
    %Post{}
    |> Post.changeset(%{})
    |> to_form(as: "post")

  socket =
  socket
  |> assign(form: form)
  |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1)

  {:ok, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save-post", %{"post" => post_params}, socket) do
    %{current_user: user} = socket.assigns

    post_params
    |> Map.put("user_id", user.id)
    |> Map.put("image_path", List.first(consume_files(socket)))
    |> Posts.save()
    |> case do
      {:ok, _post} ->
        socket =
        socket
        |> put_flash(:info, "帖子发布成功！")
        |> push_navigate(to: ~p"/home")

        {:noreply, socket}

      {:error, _changeset} ->
    {:noreply, socket}
      end
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:instagram), "static", "uploads", Path.basename(path)])
      File.cp!(path, dest)

      {:postpone, ~p"/uploads/#{Path.basename(dest)}"}
  end)
end
end
