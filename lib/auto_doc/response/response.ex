defmodule AutoDoc.Response do

  @type t :: %__MODULE__{
              body:    binary,
              status:  integer,
              headers: List.t}

  defstruct body:    nil,
            status:  nil,
            headers: []

  alias AutoDoc.Response

  @spec new(Plug.Conn.t) :: t
  def new(%Plug.Conn{resp_body: body, status: status, resp_headers: headers} = conn) do
    %Response{body: IO.iodata_to_binary(body), status: status, headers: headers}
  end

  @spec valid?(t) :: boolean
  def valid?(%Response{} = response) do
    has_json_header?(response.headers)
  end

  defp has_json_header?(headers) do
    Enum.any?(headers, fn({k,v}) ->
      k == "content-type" && v == "application/json"
    end)
  end
end
