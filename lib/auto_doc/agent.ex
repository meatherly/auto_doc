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
  def add_test_to_docs(conn, test_name) do
    request = Request.new(conn)
    response = Response.new(conn)

    Agent.get_and_update(__MODULE__, fn(docs) ->
      {docs, [%{test_name: test_name, request: request, response: response}| docs]}
    end)

    conn
  end

  @doc false
  def clear_docs do
    Agent.update(__MODULE__, fn _ -> [] end)
  end

  @doc false
  def write_file(exit_code) do
    exit_code
      |> write_file("#{Path.expand(".")}/api_docs")
  end

  @doc false
  def write_file(exit_code, file_name) do
    write_file(exit_code, file_name, "html")
  end

  @doc false
  def write_file(exit_code, file_name, tpl_format) do
    case exit_code do
      1 ->
        Mix.Shell.IO.info("Tests have failed. No docs will be generated")
      0 ->
        tests = Agent.get(__MODULE__, fn(docs) -> docs  end)
        file_contents =
          Path.join([__DIR__, "..", "templates/api_docs.#{tpl_format}.eex"])
          |> Path.expand
          |> EEx.eval_file([tests: tests])
        File.write!("#{file_name}.#{tpl_format}", file_contents)
        Mix.Shell.IO.info("Api docs have been created.")
      _ ->
        Mix.Shell.IO.info("Something Bad has happened. No docs have been generated.")
    end
  end

end
