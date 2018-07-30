defmodule AutoDocTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest AutoDoc

  @opts AutoDoc.TestApp.init([])

  setup do
    agent = Process.whereis(AutoDoc.Agent)
    {:ok, agent: agent}
  end

  # All tests below should be added to the api_docs.html

  test "testing GET requests", %{agent: agent} do
    conn =
      conn(:get, "/index", %{})
      |> AutoDoc.document_api("Retrieve a list of users")
      |> AutoDoc.TestApp.call(@opts)

    assert Agent.get(agent, fn docs -> docs end)
           |> Enum.any?(fn doc ->
             doc == %{
               response: AutoDoc.Response.new(conn),
               request: AutoDoc.Request.new(conn),
               test_name: "Retrieve a list of users"
             }
           end)
  end

  test "testing POST requests", %{agent: agent} do
    conn =
      conn(:post, "/users", %{name: "Jane Doe", email: "jane.doe@exmaple.com"})
      |> AutoDoc.document_api("Add a new user")
      |> AutoDoc.TestApp.call(@opts)

    assert Agent.get(agent, fn docs -> docs end)
           |> Enum.any?(fn doc ->
             doc == %{
               response: AutoDoc.Response.new(conn),
               request: AutoDoc.Request.new(conn),
               test_name: "Add a new user"
             }
           end)
  end

  test "testing PATCH requests", %{agent: agent} do
    conn =
      conn(:patch, "/users/2", %{name: "Jane Doe", email: "jane.doe@exmaple.org"})
      |> AutoDoc.document_api("Update a user")
      |> AutoDoc.TestApp.call(@opts)

    assert Agent.get(agent, fn docs -> docs end)
           |> Enum.any?(fn doc ->
             doc == %{
               response: AutoDoc.Response.new(conn),
               request: AutoDoc.Request.new(conn),
               test_name: "Update a user"
             }
           end)
  end

  test "testing DELETE requests", %{agent: agent} do
    conn =
      conn(:delete, "/users/1", %{})
      |> AutoDoc.document_api("Delete a user")
      |> AutoDoc.TestApp.call(@opts)

    assert Agent.get(agent, fn docs -> docs end)
           |> Enum.any?(fn doc ->
             doc == %{
               response: AutoDoc.Response.new(conn),
               request: AutoDoc.Request.new(conn),
               test_name: "Delete a user"
             }
           end)
  end
end
