<!-- CONTENT START -->

# Hello, world

**[You can find all the code for this chapter here](https://github.com/zoedsoupe/learn-elixir-with-tests/tree/main/lib/lewt/hello_world.ex)**

It is traditional for your first program in a new language to be [Hello, World](https://en.m.wikipedia.org/wiki/%22Hello,_World!%22_program).

- Create a folder wherever you like
- Put a new file in it called `hello.exs` and put the following code inside it

```elixir
defmodule HelloWorld do
  def hello do
    IO.puts("Hello, World")
  end
end

HelloWorld.hello()
```

To run it execute `elixir hello.exs`.

Note that `Elixir` is a compiled language that runs on top of [BEAM](https://en.wikipedia.org/wiki/BEAM_(Erlang_virtual_machine)) and in gereal `mix` build tool is used to compile and test `Elixir` code.

However `Elixir` allows to run code as a "script language". In this mode you need to name your file with `.exs` extension to be able to execute code in-demand. Is important to understand that difference between "compiled" and "scripted" mode is that in the first case code is compile directly to `BEAM` bytecode and can be reused/loaded anytime. On the other hand, in script mode code is compiled everytime you run the file as result is discarded.

## How it works

When you write a program in `Elixir` and want to define named functions, you need to define a module first.

The `defmodule` keyword (actually it's a macro, but that will be in a future chapter) is how you define a module with a name that follows [PascalCase](https://wiki.c2.com/?UpperCamelCase) convention and a `do-end` block that represents the module body. Think in a module as a way to group several co-related functions!

To define a function `def` keyword is used followed by it's name in [snake_case](https://en.wikipedia.org/wiki/Snake_case) and the function body wrapped in a `do-end` block.

So to print a text string we use `puts/1` function from `IO` built-in module.

## How to test

How do test this? An excellent code pattern is to separate "pure" code from the putside world [side-effects](https://softwareengineering.stackexchange.com/a/40314). Your code/function is considered pure when it doesn't relies on, or modifies something outside its scope (eg. arguments).

The `IO.puts/1` is a side-effect (printing to stdout) and the text string we sen in is our pure or "domain" code.

So let's separate these concers so it's easier to test (and maintain!)

```elixir
defmodule HelloWorld do
  def print_hello do
    IO.puts(hello())
  end

  def hello do
    "Hello, world"
  end
end
```

Now create a new module `HelloWorldTest` in `hello.exs` where we are going to write a test for our `HelloWorld` module

```elixir
# ... HelloWorld module

ExUnit.start(auto_run: false)

defmodule HelloWorldTest do
  use ExUnit.Case

  test "hello/0" do
    assert HelloWorld.hello() == "Hello, world"
  end
end

ExUnit.run()
```

`Elixir` has a built-in unit test framework called `ExUnit` which is a separate `BEAM` application that needs to be started mannually in this case.

Run `elixir hello.exs` in your terminal. It should've passed! Just to check, try deliberately breaking the test by changing the string content after the equal (`==`) operator.

> In compiled mode and in a project set up with `mix` we would create a file called `xxx_test.exs`, where `xxx` is the module to be tested, and then execute `mix test` to run it. We will see more about `mix` in future chapters!

Notice how you have not had to pick between multiple testing frameworks and then figure out how to install. Everything you need is built in to the language and the syntax is the same as the rest of the code you will write.

### Writing tests

Writing a test is just like writing a module, with a few additional steps:

- The test module name should end with the word `Test`
- `ExUnit.Case` module must be used, bringing its functionallity to the current module, so you can use "keywords" like `test` and `assert`
- To check a truthy return value you should use `assert`
- To check a falsy return value you should use `refute`

### ExDoc

Another quality of life feature of `Elixir` is the documentation. You can generate your project documentation by using [ex_doc](https://github.com/elixir-lang/ex_doc) official library.

The standard library has excellent documentation with examples. Navigating to ["Kernel" documentation](https://hexdocs.pm/elixir) would be worthwhile to see what's available to you.

<!-- CONTENT END -->