defmodule LEWT.DocParser do
  @moduledoc false
  @doc """
  Get content from a given mardown (.md or .livemd) file
  that is sandwiched by `markdown_delimiters/0`.

  ## Example
      iex> read_markdown!("./README.md")
      "README.md Content"
  """
  def read_markdown!(path) do
    {start, tail} = markdown_delimiters()

    path
    |> Path.expand()
    |> File.read!()
    |> String.split(start)
    |> Enum.at(1)
    |> String.split(tail)
    |> List.first()
  end

  @doc """
  Define start and end delimiters to easily parse markdown content.
  """
  def markdown_delimiters do
    {"<!-- CONTENT START -->", "<!-- CONTENT END -->"}
  end
end

defmodule LEWT do
  @external_resource Path.expand("./README.md")

  @moduledoc LEWT.DocParser.read_markdown!("./README.md")
end
