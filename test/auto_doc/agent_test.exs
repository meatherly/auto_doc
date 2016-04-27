defmodule AutoDoc.AgentTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  # alias AutoDoc.Agent

  test "It should not generate api docs file if exit code is 1" do
    assert capture_io(fn ->
      AutoDoc.Agent.write_file(1)
    end) == "Tests have failed. No docs will be generated\n"
  end


  test "It should generate api docs file if the exit code is 0" do
    assert capture_io(fn ->
      AutoDoc.Agent.write_file(0)
      assert File.exists?("#{Path.expand(".")}/api_docs.html")
    end) == "Api docs have been created.\n"
  end
end
