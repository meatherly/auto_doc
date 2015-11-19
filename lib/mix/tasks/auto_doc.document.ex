defmodule Mix.Tasks.AutoDoc.Document do
  use Mix.Task
  @shortdoc "Runs tests and documents then documents the APIs"
  @moduledoc false

  def run(_args) do
    Mix.env(:test)
    ExCado.DocAgent.start_link

    Mix.Task.run "compile"
    Mix.Project.compile() |> IO.inspect
    IO.inspect "SDSSS"
    Mix.Task.run "test"

    ExCado.DocAgent.get_docs
  end
end
