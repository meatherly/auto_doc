defmodule Mix.Tasks.AutoDoc.Document do
  use Mix.Task
  @shortdoc "Runs tests and documents then documents the APIs"
  @moduledoc false

  def run(_args) do
    Mix.env(:test)
    AutoDoc.Agent.start()
    Mix.Task.run("test")
  end
end
