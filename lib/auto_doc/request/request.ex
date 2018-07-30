defmodule AutoDoc.Request do
  @moduledoc """
  This is the `Request` struct.

  It pulls out `headers`, `params`, and `path` properties from the `Plug.Conn` struct.
  """
  @type headers :: [{binary, binary}]
  @type param :: binary | %{binary => param} | [param]
  @type params :: %{binary => param}
  @type path :: binary

  @type t :: %__MODULE__{headers: headers, method: binary, params: params, path: path}

  defstruct headers: [],
            method: "",
            params: %{},
            path: ""

  alias AutoDoc.Request

  @doc false
  def new(%Plug.Conn{req_headers: headers, method: method, params: params, request_path: path}) do
    %__MODULE__{headers: headers, method: method, params: params, path: path}
  end
end
