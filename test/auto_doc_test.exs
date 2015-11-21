defmodule AutoDocTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest AutoDoc

  @opts AutoDoc.TestApp.init([])

  setup do
    AutoDoc.Agent.clear_docs
    agent = Process.whereis(AutoDoc.Agent)
    {:ok, agent: agent}
  end

  test "test should be added to the AutoDoc.Agent", %{agent: agent} do
    conn =
      conn(:get, "/index")
      |> AutoDoc.document_api("Test 1")
      |> AutoDoc.TestApp.call(@opts)

    docs = Agent.get(agent, fn(docs) -> docs end)
    assert docs == [
      %{response: AutoDoc.Response.new(conn),
      request: AutoDoc.Request.new(conn),
      test_name: "Test 1"}]
  end
end
