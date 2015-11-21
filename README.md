# AutoDoc
[![Build Status](https://travis-ci.org/meatherly/auto_doc.svg)](https://travis-ci.org/meatherly/auto_doc)

`AutoDoc` is a Elixir implementation of [Avocado](https://github.com/metova/avocado). It automatically creates Web API documentation for any Elixir application using `Plug`. All docs are generated based on the requests made during the tests.


## Installation

The package can be installed as:

  1. Add auto_doc to your list of dependencies in `mix.exs`:

    ``` elixir
    def deps do
      [{:auto_doc, github: "meatherly/auto_doc"}]
    end
    ```

## Usage

  1. Add these functions to your `test_helper.exs` file:

  ``` elixir
  AutoDoc.start
  ```

  2. Add `context` to your `setup` function. Also pass the `conn` and `context[:test]` to `AutoDoc.document_api/2` in your setup block.

    ``` elixir
    setup context do
      conn =
        conn()
        |> AutoDoc.document_api(context[:test])
      {:ok, conn: conn}
    end
    ```

  3. Run `mix test`. This will create a `api-docs.html` file at the root of your project which you can then open with a web browser.


  *For large teams you'll want to add `api-docs.html` to your `.gitignore`*

  ## Todo

  * Clean up code!
  * Make Hex package
  * Create a cowboy server to serve the `api-docs.html` via router `Plug`.
  * Allow user to set an `ENV` to determine whether to create docs or not. This way they can create the docs on the build server.
