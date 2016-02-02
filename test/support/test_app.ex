defmodule AutoDoc.TestApp do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/index" do
    users = Poison.encode!([%{id: 1, name: "John Doe", email: "john.doe@example.com"}])
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, users)
  end

  post "/users" do
    user = Map.put(conn.params, :id, 2)
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(201, Poison.encode!(user))
  end

  patch "/users/:user_id" do
    user = Map.put(conn.params, :id, user_id)
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Poison.encode!(user))
  end

  delete "/users/:user_id" do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(:no_content, "")
  end
end
