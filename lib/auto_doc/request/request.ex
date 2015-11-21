defmodule AutoDoc.Request do
  @type headers         :: [{binary, binary}]
  @type method          :: binary
  @type param           :: binary | %{binary => param} | [param]
  @type params          :: %{binary => param}
  @type path            :: binary

  @type t :: %__MODULE__{
              headers: headers,
              method: method,
              params: params,
              path: path
}

  defstruct headers:         [],
            method:          "",
            params:          %{},
            path:            ""

  alias AutoDoc.Request


  def new(%Plug.Conn{req_headers: headers, method: method, params: params, request_path: path} = conn) do
    %Request{headers: headers, method: method, params: params, path: path}
  end
end
