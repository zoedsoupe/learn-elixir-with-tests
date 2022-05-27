ExUnit.start(auto_run: false)

defmodule LEWT.HelloWorld do
  @moduledoc LEWT.DocParser.read_markdown!("./lib/lewt/hello_world/hello_world.md")

  @doc """
  Chapter entrypoint, `init/0` only prints a
  "Hello, world" string.
  """
  def init do
    IO.puts("Hello, world")
  end

  @doc """
  Prints a greeting.
  """
  def print_hello do
    IO.puts(hello())
  end

  @doc """
  Returns a greeting.
  """
  def hello do
    "Hello, world"
  end

  @doc """
  Returns a personalized greeting.
  """
  def hello(name) do
    # "Hello, #{name}"
    "Hello, " <> name
  end

  @doc """
  Retuns a personalized greeting in a given language.
  """
  def hello(name, :spanish) do
    "Hola, " <> name
  end

  def hello(name, :french) do
    "Bonjour, " <> name
  end

  def hello(name, _unkown) do
    "Hello, " <> name
  end
end

defmodule LEWT.HelloWorldTest do
  use ExUnit.Case, async: false

  alias LEWT.HelloWorld

  test "hello/0" do
    assert HelloWorld.hello() == "Hello, world"
  end

  test "hello/1" do
    assert HelloWorld.hello("Zoey") == "Hello, Zoey"
  end

  test "hello/2" do
    assert HelloWorld.hello("Yan", :spanish) == "Hola, Yan"
    assert HelloWorld.hello("Thay", :french) == "Bonjour, Thay"
  end
end

ExUnit.run()
