defmodule ThetaWeb.Plug.Rbac do
  use Plug.Builder

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    role = :admin
    config = Application.get_env(:theta_web, :rbac)
    IO.inspect config[:effect], label: "Effect==============\n"
    IO.inspect config[:policy], label: "Policy==============\n"

    effect = config[:effect] == :allow
    IO.inspect effect, label: "Effect true false==============\n"
    info = Phoenix.Router.route_info(ThetaWeb.Router, conn.method, conn.request_path, conn.host)
    case {effect, Map.has_key?(config[:policy], role)}do
      {true, true} ->
        # Allow have policy => check
        conn
      {true, false} ->
        # Allow not policy => not permission
        conn
      {false, true} ->
        # Deny have policy => check
        conn
      {_, _} ->
        # Deny not policy => ok
        conn
    end
  end

  defp matchers(conn, info) do
    # Request definition
    # [request_definition]
    # r = sub, obj, act
    #
    # # Policy definition
    # [policy_definition]
    # p = sub, obj, act
    #
    # # Policy effect
    # [policy_effect]
    # e = some(where (p.eft == allow))
    #
    # # Matchers
    # [matchers]
    # m = r.sub == p.sub && r.obj == p.obj && r.act == p.act
    #    IO.inspect conn, label: "RBAC==============\n"
    #    IO.inspect conn.request_path, label: "RBAC==============\n"
    #    info = Phoenix.Router.route_info(ThetaWeb.Router, conn.method, conn.request_path, conn.host)
    IO.inspect info, label: "INFO==============\n"
    config = Application.get_env(:theta_web, :rbac)
    IO.inspect config[:effect], label: "Effect==============\n"
    IO.inspect config[:policy], label: "Policy==============\n"
    #    m = r.sub == p.sub && r.obj == p.obj && r.act == p.act
    role = :admin
    #    m = r.sub == p.sub && r.obj == p.obj && r.act == p.act
  end
end
