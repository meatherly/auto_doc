defmodule AutoDoc.Agent do
  @moduledoc false

  alias AutoDoc.Request
  alias AutoDoc.Response

  @doc false
  def start_link do
    System.at_exit(&AutoDoc.Agent.write_file/1)
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @doc false
  def add_test_to_docs(conn, test_name, opts \\ []) do
    opts = opts ++ [file_name: "#{Path.expand(".")}/api_docs", file_format: "html"]
    request = Request.new(conn)
    response = Response.new(conn)

    Agent.get_and_update(__MODULE__, fn(docs) ->
      {docs, [%{test_name: test_name,
                request: request,
                response: response,
                file_name: opts[:file_name],
                file_format: opts[:file_format]}| docs]}
    end)

    conn
  end

  @doc false
  def clear_docs do
    Agent.update(__MODULE__, fn _ -> [] end)
  end

  @doc false
  def write_file(exit_code) do
    case exit_code do
      1 ->
        Mix.Shell.IO.info("Tests have failed. No docs will be generated")
      0 ->
        __MODULE__
          |> Agent.get(fn(docs) -> docs  end)
          |> Enum.group_by(fn(item) -> {item[:file_name], item[:file_format]} end)
          |> Enum.map(fn({{file_name, file_format}, tests}) ->
            file_contents =
              Path.join([__DIR__, "..", "templates/api_docs.#{file_format}.eex"])
              |> Path.expand
              |> EEx.eval_file([tests: tests])
            File.write!("#{file_name}.#{file_format}", file_contents)
          end)
        Mix.Shell.IO.info("Api docs have been created.")
      _ ->
        Mix.Shell.IO.info("Something Bad has happened. No docs have been generated.")
    end
  end

end
