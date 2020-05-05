defmodule ThetaWeb.CMS.TaxonomyControllerTest do
  use ThetaWeb.ConnCase

  alias Theta.CMS

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  def fixture(:taxonomy) do
    {:ok, taxonomy} = CMS.create_taxonomy(@create_attrs)
    taxonomy
  end

  describe "index" do
    test "lists all taxonomy", %{conn: conn} do
      conn = get(conn, Routes.cms_taxonomy_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Taxonomy"
    end
  end

  describe "new taxonomy" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.cms_taxonomy_path(conn, :new))
      assert html_response(conn, 200) =~ "New Taxonomy"
    end
  end

  describe "create taxonomy" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cms_taxonomy_path(conn, :create), taxonomy: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cms_taxonomy_path(conn, :show, id)

      conn = get(conn, Routes.cms_taxonomy_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Taxonomy"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cms_taxonomy_path(conn, :create), taxonomy: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Taxonomy"
    end
  end

  describe "edit taxonomy" do
    setup [:create_taxonomy]

    test "renders form for editing chosen taxonomy", %{conn: conn, taxonomy: taxonomy} do
      conn = get(conn, Routes.cms_taxonomy_path(conn, :edit, taxonomy))
      assert html_response(conn, 200) =~ "Edit Taxonomy"
    end
  end

  describe "update taxonomy" do
    setup [:create_taxonomy]

    test "redirects when data is valid", %{conn: conn, taxonomy: taxonomy} do
      conn = put(conn, Routes.cms_taxonomy_path(conn, :update, taxonomy), taxonomy: @update_attrs)
      assert redirected_to(conn) == Routes.cms_taxonomy_path(conn, :show, taxonomy)

      conn = get(conn, Routes.cms_taxonomy_path(conn, :show, taxonomy))
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, taxonomy: taxonomy} do
      conn = put(conn, Routes.cms_taxonomy_path(conn, :update, taxonomy), taxonomy: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Taxonomy"
    end
  end

  describe "delete taxonomy" do
    setup [:create_taxonomy]

    test "deletes chosen taxonomy", %{conn: conn, taxonomy: taxonomy} do
      conn = delete(conn, Routes.cms_taxonomy_path(conn, :delete, taxonomy))
      assert redirected_to(conn) == Routes.cms_taxonomy_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.cms_taxonomy_path(conn, :show, taxonomy))
      end
    end
  end

  defp create_taxonomy(_) do
    taxonomy = fixture(:taxonomy)
    {:ok, taxonomy: taxonomy}
  end
end
