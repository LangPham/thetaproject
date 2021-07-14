defmodule ThetaWeb.ArticleTaggingLive do
  use ThetaWeb, :live_view
  use ThetaMedia

  @impl true
  def render(assigns) do
    ThetaWeb.CMS.ArticleView.render("tagging.html", assigns)
  end

  @impl true
  def mount(_params, %{"id" => article_id} = session, socket) do
    {list_tag, tagged }= fetch_register(article_id)
    assigns = [
      list_tag: list_tag -- tagged,
      taggings: tagged,
      tags: [],
      search_results: [],
      search_phrase: ""
    ]
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("pick", %{"id" => term_id}, socket) do
    tag = socket.assigns.list_tag |> Enum.filter(fn tag -> tag.id == term_id  end)
    assigns = [
      list_tag: socket.assigns.list_tag -- tag,
      taggings: socket.assigns.taggings ++ tag,
      search_results: [],
      search_phrase: ""
    ]
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("new", %{"id" => term_id}, socket) do
    new_tag = %{name: term_id, id: Slug.slugify(String.downcase(term_id)), action: :create}
    assigns = [
      list_tag: socket.assigns.list_tag ,
      taggings: socket.assigns.taggings ++ [new_tag],
      search_results: [],
      search_phrase: ""
    ]
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("delete", %{"id" => term_id}, socket) do
    tag = socket.assigns.taggings |> Enum.filter(fn tag -> tag.id == term_id  end)
    assigns = [
      list_tag: socket.assigns.list_tag ++ tag,
      taggings: socket.assigns.taggings -- tag,
      search_results: [],
      search_phrase: ""
    ]
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("keyup", %{"value" => value}, socket) do
    assigns = [
      list_tag: socket.assigns.list_tag,
      taggings: socket.assigns.taggings,
      search_results: search(socket.assigns.list_tag,value),
      search_phrase: value
    ]
    {:noreply, assign(socket, assigns)}
  end

  def fetch_register(article_id) do
    Theta.CMS.list_tag()
    tagged =
      if article_id != nil do
        a = Theta.CMS.get_article!(article_id)
        a.tag
      else
        []
      end
    {Theta.CMS.list_tag(), tagged}
  end


  defp search(_, ""), do: []
  defp search(tags, search_phrase) do
    tags
    |> Enum.filter(fn tag -> Regex.match?(~r/#{Slug.slugify(String.downcase(search_phrase))}/, Slug.slugify(String.downcase(tag.name)))  end)
  end
end
