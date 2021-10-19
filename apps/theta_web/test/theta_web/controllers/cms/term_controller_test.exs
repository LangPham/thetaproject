defmodule ThetaWeb.CMS.TermControllerTest do
  use ThetaWeb.ConnCase

  alias Theta.CMS

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  def fixture(:term) do
    {:ok, term} = CMS.create_term(@create_attrs)
    term
  end

  describe "index" do
    test "lists all term", %{conn: conn} do
      conn = get(conn, Routes.cms_term_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Term"
    end
  end

  describe "new term" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.cms_term_path(conn, :new))
      assert html_response(conn, 200) =~ "New Term"
    end
  end

  describe "create term" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cms_term_path(conn, :create), term: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cms_term_path(conn, :show, id)

      conn = get(conn, Routes.cms_term_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Term"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cms_term_path(conn, :create), term: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Term"
    end
  end

  describe "edit term" do
    setup [:create_term]

    test "renders form for editing chosen term", %{conn: conn, term: term} do
      conn = get(conn, Routes.cms_term_path(conn, :edit, term))
      assert html_response(conn, 200) =~ "Edit Term"
    end
  end

  describe "update term" do
    setup [:create_term]

    test "redirects when data is valid", %{conn: conn, term: term} do
      conn = put(conn, Routes.cms_term_path(conn, :update, term), term: @update_attrs)
      assert redirected_to(conn) == Routes.cms_term_path(conn, :show, term)

      conn = get(conn, Routes.cms_term_path(conn, :show, term))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, term: term} do
      conn = put(conn, Routes.cms_term_path(conn, :update, term), term: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Term"
    end
  end

  describe "delete term" do
    setup [:create_term]

    test "deletes chosen term", %{conn: conn, term: term} do
      conn = delete(conn, Routes.cms_term_path(conn, :delete, term))
      assert redirected_to(conn) == Routes.cms_term_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.cms_term_path(conn, :show, term))
      end
    end
  end

  defp create_term(_) do
    term = fixture(:term)
    {:ok, term: term}
  end
end
