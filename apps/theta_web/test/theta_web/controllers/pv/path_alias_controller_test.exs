defmodule ThetaWeb.PV.PathAliasControllerTest do
  use ThetaWeb.ConnCase

  alias Theta.PV

  @create_attrs %{slug: "some slug", type_model: "some type_model"}
  @update_attrs %{slug: "some updated slug", type_model: "some updated type_model"}
  @invalid_attrs %{slug: nil, type_model: nil}

  def fixture(:path_alias) do
    {:ok, path_alias} = PV.create_path_alias(@create_attrs)
    path_alias
  end

  describe "index" do
    test "lists all path_alias", %{conn: conn} do
      conn = get(conn, Routes.pv_path_alias_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Path alias"
    end
  end

  describe "new path_alias" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.pv_path_alias_path(conn, :new))
      assert html_response(conn, 200) =~ "New Path alias"
    end
  end

  describe "create path_alias" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pv_path_alias_path(conn, :create), path_alias: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pv_path_alias_path(conn, :show, id)

      conn = get(conn, Routes.pv_path_alias_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Path alias"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pv_path_alias_path(conn, :create), path_alias: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Path alias"
    end
  end

  describe "edit path_alias" do
    setup [:create_path_alias]

    test "renders form for editing chosen path_alias", %{conn: conn, path_alias: path_alias} do
      conn = get(conn, Routes.pv_path_alias_path(conn, :edit, path_alias))
      assert html_response(conn, 200) =~ "Edit Path alias"
    end
  end

  describe "update path_alias" do
    setup [:create_path_alias]

    test "redirects when data is valid", %{conn: conn, path_alias: path_alias} do
      conn =
        put(conn, Routes.pv_path_alias_path(conn, :update, path_alias), path_alias: @update_attrs)

      assert redirected_to(conn) == Routes.pv_path_alias_path(conn, :show, path_alias)

      conn = get(conn, Routes.pv_path_alias_path(conn, :show, path_alias))
      assert html_response(conn, 200) =~ "some updated slug"
    end

    test "renders errors when data is invalid", %{conn: conn, path_alias: path_alias} do
      conn =
        put(conn, Routes.pv_path_alias_path(conn, :update, path_alias), path_alias: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Path alias"
    end
  end

  describe "delete path_alias" do
    setup [:create_path_alias]

    test "deletes chosen path_alias", %{conn: conn, path_alias: path_alias} do
      conn = delete(conn, Routes.pv_path_alias_path(conn, :delete, path_alias))
      assert redirected_to(conn) == Routes.pv_path_alias_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.pv_path_alias_path(conn, :show, path_alias))
      end
    end
  end

  defp create_path_alias(_) do
    path_alias = fixture(:path_alias)
    {:ok, path_alias: path_alias}
  end
end
