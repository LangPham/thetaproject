defmodule Theta.PVTest do
  use Theta.DataCase

  alias Theta.PV

  describe "path_alias" do
    alias Theta.PV.PathAlias

    @valid_attrs %{slug: "some slug", type_model: "some type_model"}
    @update_attrs %{slug: "some updated slug", type_model: "some updated type_model"}
    @invalid_attrs %{slug: nil, type_model: nil}

    def path_alias_fixture(attrs \\ %{}) do
      {:ok, path_alias} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PV.create_path_alias()

      path_alias
    end

    test "list_path_alias/0 returns all path_alias" do
      path_alias = path_alias_fixture()
      assert PV.list_path_alias() == [path_alias]
    end

    test "get_path_alias!/1 returns the path_alias with given id" do
      path_alias = path_alias_fixture()
      assert PV.get_path_alias!(path_alias.id) == path_alias
    end

    test "create_path_alias/1 with valid data creates a path_alias" do
      assert {:ok, %PathAlias{} = path_alias} = PV.create_path_alias(@valid_attrs)
      assert path_alias.slug == "some slug"
      assert path_alias.type_model == "some type_model"
    end

    test "create_path_alias/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PV.create_path_alias(@invalid_attrs)
    end

    test "update_path_alias/2 with valid data updates the path_alias" do
      path_alias = path_alias_fixture()
      assert {:ok, %PathAlias{} = path_alias} = PV.update_path_alias(path_alias, @update_attrs)
      assert path_alias.slug == "some updated slug"
      assert path_alias.type_model == "some updated type_model"
    end

    test "update_path_alias/2 with invalid data returns error changeset" do
      path_alias = path_alias_fixture()
      assert {:error, %Ecto.Changeset{}} = PV.update_path_alias(path_alias, @invalid_attrs)
      assert path_alias == PV.get_path_alias!(path_alias.id)
    end

    test "delete_path_alias/1 deletes the path_alias" do
      path_alias = path_alias_fixture()
      assert {:ok, %PathAlias{}} = PV.delete_path_alias(path_alias)
      assert_raise Ecto.NoResultsError, fn -> PV.get_path_alias!(path_alias.id) end
    end

    test "change_path_alias/1 returns a path_alias changeset" do
      path_alias = path_alias_fixture()
      assert %Ecto.Changeset{} = PV.change_path_alias(path_alias)
    end
  end

  describe "path_error" do
    alias Theta.PV.PathError

    @valid_attrs %{forward: "some forward", path: "some path", view: 42}
    @update_attrs %{forward: "some updated forward", path: "some updated path", view: 43}
    @invalid_attrs %{forward: nil, path: nil, view: nil}

    def path_error_fixture(attrs \\ %{}) do
      {:ok, path_error} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PV.create_path_error()

      path_error
    end

    test "list_path_error/0 returns all path_error" do
      path_error = path_error_fixture()
      assert PV.list_path_error() == [path_error]
    end

    test "get_path_error!/1 returns the path_error with given id" do
      path_error = path_error_fixture()
      assert PV.get_path_error!(path_error.id) == path_error
    end

    test "create_path_error/1 with valid data creates a path_error" do
      assert {:ok, %PathError{} = path_error} = PV.create_path_error(@valid_attrs)
      assert path_error.forward == "some forward"
      assert path_error.path == "some path"
      assert path_error.view == 42
    end

    test "create_path_error/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PV.create_path_error(@invalid_attrs)
    end

    test "update_path_error/2 with valid data updates the path_error" do
      path_error = path_error_fixture()
      assert {:ok, %PathError{} = path_error} = PV.update_path_error(path_error, @update_attrs)
      assert path_error.forward == "some updated forward"
      assert path_error.path == "some updated path"
      assert path_error.view == 43
    end

    test "update_path_error/2 with invalid data returns error changeset" do
      path_error = path_error_fixture()
      assert {:error, %Ecto.Changeset{}} = PV.update_path_error(path_error, @invalid_attrs)
      assert path_error == PV.get_path_error!(path_error.id)
    end

    test "delete_path_error/1 deletes the path_error" do
      path_error = path_error_fixture()
      assert {:ok, %PathError{}} = PV.delete_path_error(path_error)
      assert_raise Ecto.NoResultsError, fn -> PV.get_path_error!(path_error.id) end
    end

    test "change_path_error/1 returns a path_error changeset" do
      path_error = path_error_fixture()
      assert %Ecto.Changeset{} = PV.change_path_error(path_error)
    end
  end
end
