defmodule AutoDoc.Agent do
  def start_link do
    System.at_exit(&AutoDoc.Agent.write_file/1)
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_test_to_docs(conn, test_name) do
    Agent.get_and_update(__MODULE__, fn(docs) ->
      %{params: params, req_headers: req_headers, method: method, request_path: request_path} = conn
      request = %{params: params, req_headers: req_headers, method: method, request_path: request_path}
      %{resp_body: resp_body, status: status} = conn
      response = %{resp_body: IO.iodata_to_binary(resp_body), status: status}
      {docs, [%{test_name: test_name, request: request, response: response}| docs]}
    end)
    conn
  end



  def write_file(exit_code) do
    case exit_code do
      1 ->
        Mix.Shell.IO.info("Tests have failed. No docs will be generated")
      0 ->
        tests = Agent.get(__MODULE__, fn(docs) -> docs  end)
        file_contents =
          Path.join([__DIR__, "..", "templates/api_docs.html.eex"])
          |> Path.expand
          |> EEx.eval_file([tests: tests])
        File.write!("#{Path.expand(".")}/api_docs.html", file_contents)
        Mix.Shell.IO.info("Api docs have been created.")
      _ ->
        Mix.Shell.IO.info("Something Bad has happened. No docs have been generated.")
    end
  end
end
