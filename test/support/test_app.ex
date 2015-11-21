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

  post "/new" do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(201, "")
  end

  delete "/delete" do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(201, "")
  end

  get "/html" do
    conn
    |> put_resp_header("content-type", "text/html")
    |> send_resp(200, "<html></html>")
  end

end
