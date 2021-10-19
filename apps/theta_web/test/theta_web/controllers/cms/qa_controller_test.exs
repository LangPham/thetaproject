defmodule ThetaWeb.Cms.QaControllerTest do
  use ThetaWeb.ConnCase

  alias Theta.Cms

  @create_attrs %{answer: "some answer", question: "some question", tag: "some tag"}
  @update_attrs %{
    answer: "some updated answer",
    question: "some updated question",
    tag: "some updated tag"
  }
  @invalid_attrs %{answer: nil, question: nil, tag: nil}

  def fixture(:qa) do
    {:ok, qa} = Cms.create_qa(@create_attrs)
    qa
  end

  describe "index" do
    test "lists all qa", %{conn: conn} do
      conn = get(conn, Routes.cms_qa_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Qa"
    end
  end

  describe "new qa" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.cms_qa_path(conn, :new))
      assert html_response(conn, 200) =~ "New Qa"
    end
  end

  describe "create qa" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cms_qa_path(conn, :create), qa: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cms_qa_path(conn, :show, id)

      conn = get(conn, Routes.cms_qa_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Qa"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cms_qa_path(conn, :create), qa: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Qa"
    end
  end

  describe "edit qa" do
    setup [:create_qa]

    test "renders form for editing chosen qa", %{conn: conn, qa: qa} do
      conn = get(conn, Routes.cms_qa_path(conn, :edit, qa))
      assert html_response(conn, 200) =~ "Edit Qa"
    end
  end

  describe "update qa" do
    setup [:create_qa]

    test "redirects when data is valid", %{conn: conn, qa: qa} do
      conn = put(conn, Routes.cms_qa_path(conn, :update, qa), qa: @update_attrs)
      assert redirected_to(conn) == Routes.cms_qa_path(conn, :show, qa)

      conn = get(conn, Routes.cms_qa_path(conn, :show, qa))
      assert html_response(conn, 200) =~ "some updated answer"
    end

    test "renders errors when data is invalid", %{conn: conn, qa: qa} do
      conn = put(conn, Routes.cms_qa_path(conn, :update, qa), qa: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Qa"
    end
  end

  describe "delete qa" do
    setup [:create_qa]

    test "deletes chosen qa", %{conn: conn, qa: qa} do
      conn = delete(conn, Routes.cms_qa_path(conn, :delete, qa))
      assert redirected_to(conn) == Routes.cms_qa_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.cms_qa_path(conn, :show, qa))
      end
    end
  end

  defp create_qa(_) do
    qa = fixture(:qa)
    %{qa: qa}
  end
end
