defmodule AutoDoc do
  use Application

  @doc """
  Starts the `AutoDoc.Agent` to record all the API interactions. It's just a wrapper around `Application.ensure_all_started(:auto_doc)`.
  """
  def start do
    Application.ensure_all_started(:auto_doc)
  end

  @doc false
  def start(_,_) do
    import Supervisor.Spec, warn: false
    children = [
      worker(AutoDoc.Agent, [])
    ]
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AutoDoc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  This function registers a `before_send` callback that will record the API interactions.

  ## Examples
  ``` elixir
  setup context do
    conn =
      conn()
      |> AutoDoc.document_api(context[:test], context[:auto_doc])
    {:ok, conn: conn}
  end

  @tag auto_doc: [file_name: "priv/docs/file1", file_format: "md"]
  test "testing ...." do
    ...
  end

  @tag auto_doc: [file_name: "priv/docs/file2", file_format: "html"]
  test "testing ..." do
    ...
  end

  ```
  """
  @spec document_api(Plug.Conn.t, binary, list) :: no_return
  def document_api(%Plug.Conn{} = conn, test_name, opts \\ []) do
    if Process.whereis(AutoDoc.Agent) do
      Plug.Conn.register_before_send(conn, fn(conn) ->
        AutoDoc.Agent.add_test_to_docs(conn, test_name, opts)
      end)
    else
      conn
    end
  end
end
