defmodule AutoDoc.TestApp do
  use Plug.Router
  
  plug :match
  plug :dispatch

  get "/index" do
    users = Poison.encode!([%{name: "John Doe", email: "john.doe@example.com"}])
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, users)
  end
end
