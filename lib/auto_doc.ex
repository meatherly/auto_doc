defmodule AutoDoc do
  use Application

  def start do
    import Supervisor.Spec, warn: false

    children = [
      worker(AutoDoc.Agent, [])
    ]
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AutoDoc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def document_api(%Plug.Conn{} = conn, test_name) do
    Plug.Conn.register_before_send(conn, fn(conn) ->
      AutoDoc.Agent.add_conn_to_docs(conn, test_name)
    end)
  end
end
