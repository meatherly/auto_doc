defmodule AutoDoc.Response do
  @moduledoc """
  This is the `Response` struct.

  It pulls out `body` and `status` properties from the `Plug.Conn` struct.
  """
  @type t :: %__MODULE__{body: binary, status: integer, headers: List.t()}

  defstruct body: nil,
            status: nil,
            headers: []

  @doc false
  def new(%Plug.Conn{resp_body: body, status: status, resp_headers: headers}) do
    %__MODULE__{body: IO.iodata_to_binary(body), status: status, headers: headers}
  end

  defp has_json_header?(headers) do
    Enum.any?(headers, fn {k, v} ->
      k == "content-type" && v == "application/json"
    end)
  end
end
