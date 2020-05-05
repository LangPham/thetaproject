defmodule Theta.CMSTest do
  use Theta.DataCase

  alias Theta.CMS

  describe "taxonomy" do
    alias Theta.CMS.Taxonomy

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def taxonomy_fixture(attrs \\ %{}) do
      {:ok, taxonomy} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_taxonomy()

      taxonomy
    end

    test "list_taxonomy/0 returns all taxonomy" do
      taxonomy = taxonomy_fixture()
      assert CMS.list_taxonomy() == [taxonomy]
    end

    test "get_taxonomy!/1 returns the taxonomy with given id" do
      taxonomy = taxonomy_fixture()
      assert CMS.get_taxonomy!(taxonomy.id) == taxonomy
    end

    test "create_taxonomy/1 with valid data creates a taxonomy" do
      assert {:ok, %Taxonomy{} = taxonomy} = CMS.create_taxonomy(@valid_attrs)
      assert taxonomy.title == "some title"
    end

    test "create_taxonomy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_taxonomy(@invalid_attrs)
    end

    test "update_taxonomy/2 with valid data updates the taxonomy" do
      taxonomy = taxonomy_fixture()
      assert {:ok, %Taxonomy{} = taxonomy} = CMS.update_taxonomy(taxonomy, @update_attrs)
      assert taxonomy.title == "some updated title"
    end

    test "update_taxonomy/2 with invalid data returns error changeset" do
      taxonomy = taxonomy_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_taxonomy(taxonomy, @invalid_attrs)
      assert taxonomy == CMS.get_taxonomy!(taxonomy.id)
    end

    test "delete_taxonomy/1 deletes the taxonomy" do
      taxonomy = taxonomy_fixture()
      assert {:ok, %Taxonomy{}} = CMS.delete_taxonomy(taxonomy)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_taxonomy!(taxonomy.id) end
    end

    test "change_taxonomy/1 returns a taxonomy changeset" do
      taxonomy = taxonomy_fixture()
      assert %Ecto.Changeset{} = CMS.change_taxonomy(taxonomy)
    end
  end

  describe "term" do
    alias Theta.CMS.Term

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def term_fixture(attrs \\ %{}) do
      {:ok, term} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_term()

      term
    end

    test "list_term/0 returns all term" do
      term = term_fixture()
      assert CMS.list_term() == [term]
    end

    test "get_term!/1 returns the term with given id" do
      term = term_fixture()
      assert CMS.get_term!(term.id) == term
    end

    test "create_term/1 with valid data creates a term" do
      assert {:ok, %Term{} = term} = CMS.create_term(@valid_attrs)
      assert term.title == "some title"
    end

    test "create_term/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_term(@invalid_attrs)
    end

    test "update_term/2 with valid data updates the term" do
      term = term_fixture()
      assert {:ok, %Term{} = term} = CMS.update_term(term, @update_attrs)
      assert term.title == "some updated title"
    end

    test "update_term/2 with invalid data returns error changeset" do
      term = term_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_term(term, @invalid_attrs)
      assert term == CMS.get_term!(term.id)
    end

    test "delete_term/1 deletes the term" do
      term = term_fixture()
      assert {:ok, %Term{}} = CMS.delete_term(term)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_term!(term.id) end
    end

    test "change_term/1 returns a term changeset" do
      term = term_fixture()
      assert %Ecto.Changeset{} = CMS.change_term(term)
    end
  end

  describe "author" do
    alias Theta.CMS.Author

    @valid_attrs %{role: "some role"}
    @update_attrs %{role: "some updated role"}
    @invalid_attrs %{role: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_author()

      author
    end

    test "list_author/0 returns all author" do
      author = author_fixture()
      assert CMS.list_author() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert CMS.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = CMS.create_author(@valid_attrs)
      assert author.role == "some role"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, %Author{} = author} = CMS.update_author(author, @update_attrs)
      assert author.role == "some updated role"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_author(author, @invalid_attrs)
      assert author == CMS.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = CMS.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = CMS.change_author(author)
    end
  end


  describe "article" do
    alias Theta.CMS.Article

    @valid_attrs %{body: "some body", summary: "some summary", title: "some title"}
    @update_attrs %{body: "some updated body", summary: "some updated summary", title: "some updated title"}
    @invalid_attrs %{body: nil, summary: nil, title: nil}

    def article_fixture(attrs \\ %{}) do
      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_article()

      article
    end

    test "list_article/0 returns all article" do
      article = article_fixture()
      assert CMS.list_article() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert CMS.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      assert {:ok, %Article{} = article} = CMS.create_article(@valid_attrs)
      assert article.body == "some body"
      assert article.summary == "some summary"
      assert article.title == "some title"
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      assert {:ok, %Article{} = article} = CMS.update_article(article, @update_attrs)
      assert article.body == "some updated body"
      assert article.summary == "some updated summary"
      assert article.title == "some updated title"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_article(article, @invalid_attrs)
      assert article == CMS.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = CMS.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = CMS.change_article(article)
    end
  end
end
