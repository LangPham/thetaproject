defmodule Theta.ConfigurationTest do
  use Theta.DataCase

  alias Theta.Configuration

  describe "config" do
    alias Theta.Configuration.Config

    @valid_attrs %{key: "some key", value: "some value"}
    @update_attrs %{key: "some updated key", value: "some updated value"}
    @invalid_attrs %{key: nil, value: nil}

    def config_fixture(attrs \\ %{}) do
      {:ok, config} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Configuration.create_config()

      config
    end

    test "list_config/0 returns all config" do
      config = config_fixture()
      assert Configuration.list_config() == [config]
    end

    test "get_config!/1 returns the config with given id" do
      config = config_fixture()
      assert Configuration.get_config!(config.id) == config
    end

    test "create_config/1 with valid data creates a config" do
      assert {:ok, %Config{} = config} = Configuration.create_config(@valid_attrs)
      assert config.key == "some key"
      assert config.value == "some value"
    end

    test "create_config/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Configuration.create_config(@invalid_attrs)
    end

    test "update_config/2 with valid data updates the config" do
      config = config_fixture()
      assert {:ok, %Config{} = config} = Configuration.update_config(config, @update_attrs)
      assert config.key == "some updated key"
      assert config.value == "some updated value"
    end

    test "update_config/2 with invalid data returns error changeset" do
      config = config_fixture()
      assert {:error, %Ecto.Changeset{}} = Configuration.update_config(config, @invalid_attrs)
      assert config == Configuration.get_config!(config.id)
    end

    test "delete_config/1 deletes the config" do
      config = config_fixture()
      assert {:ok, %Config{}} = Configuration.delete_config(config)
      assert_raise Ecto.NoResultsError, fn -> Configuration.get_config!(config.id) end
    end

    test "change_config/1 returns a config changeset" do
      config = config_fixture()
      assert %Ecto.Changeset{} = Configuration.change_config(config)
    end
  end
end
