defmodule Mix.Tasks.AutoDoc.Document do
  use Mix.Task
  @shortdoc "Runs tests and documents then documents the APIs"
  @moduledoc false

  def run(_args) do
    Mix.env(:test)
    AutoDoc.DocAgent.start_link
    Mix.Task.run "test"
    AutoDoc.DocAgent.get_docs
  end
end
