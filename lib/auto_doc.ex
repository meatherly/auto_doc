defmodule ExCado do

  def document_api(%Plug.Conn{} = conn, test_name) do
    Plug.Conn.register_before_send(conn, fn(conn) ->
      ExCado.DocAgent.add_conn_to_docs(conn, test_name)
    end)
  end
end
