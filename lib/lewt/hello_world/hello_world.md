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

### Hello, YOU

Now that we have a test we can iterate on our software safely.

In the last example we wrote the test _after_ the code had been written just so you could get an example of how to write a test and define a function. From this point on we will be _writing tests first_.

Our next requirement is to let us specify the recipient of the greeting.

Let's start by capturing these requirements in a test. This is basic test driven development and allows us to make sure our test is _actually_ testing what we want. When you retrospectively write tests there is the risk that your test may continue to pass even if the code doesn't work as intended.

To achieve this, let's crate a new `test` block inside `HelloWorldTest` module created before

```elixir
test "hello/1" do
  assert HelloWorld.hello("Zoey") == "Hello, Zoey"
end
```

Now run `elixir hello.exs`, you should have a test failure like

```sh
  1) test hello/1 (HelloWorldTest)
     hello.exs:20
     ** (UndefinedFunctionError) function HelloWorld.hello/1 is undefined or private. Didyou mean one of:

           * hello/0

     code: assert HelloWorld.hello("Zoey") == "Hello, Zoey"
     stacktrace:
       HelloWorld.hello("Zoey")
       hello.exs:21: (test)



Finished in 0.00 seconds (0.00s async, 0.00s sync)
2 tests, 1 failure

Randomized with seed 215806
```

Although `Elixir` is a compiled language there's no statically type inference so the compiler tries to run tests and fails.

Now it's the perfect momento to understand why we're using `function/x` notation. `Elixir` allows developers to implement multi clause functions with same or different arguments arity.

This means that `hello/0` represents a function named "hello" that receives no arguments meanwhile `hello/1` is a function also named "hello" but receives only one argument. Note that there's no [function overloading](https://en.wikipedia.org/wiki/Function_overloading) in `Elixir`. Actually the compiler understand `hello/0` and `hello/1` as different functions.

In this case, the compiler is teeling you that there's no "hello" function that recevies an argument defined in `HelloWorld` module.

So we have to add a new "hello" clause in our module that receives an argument (you can use another function name too)

```elixir
def hello(name) do
  "Hello, world"
end
```

If you try and run your tests again your `hello.exs` last test will fail again because you're not using the given "name" argument at all.

```sh
  1) test hello/1 (HelloWorldTest)
     hello.exs:24
     Assertion with == failed
     code:  assert HelloWorld.hello("Zoey") == "Hello, Zoey"
     left:  "Hello, world"
     right: "Hello, Zoey"
     stacktrace:
       hello.exs:25: (test)

.

Finished in 0.00 seconds (0.00s async, 0.00s sync)
2 tests, 1 failure

Randomized with seed 840714
```

Let's make the test pass by using the "name" argument and concatenate it with `Hello, `

```elixir
def hello(name) do
  # "Hello, #{name}"
  "Hello, " <> name
end
```

To concatenate text string we use `<>/2` operator (see, operators in `Elixir` are only functions or _macros_ with their own arity!).

We can also use string interpolation with `Hello, #{name}` syntax expression to insert "name" value into an existing string!

When you run the tests they should now pass. Normally as part of the TDD cycle we should now _refactor_.

### A note on source control

At this point, if you are using source control (which you should!) I would
`commit` the code as it is. We have working software backed by a test.

I _wouldn't_ push to `main` though, because I plan to refactor next. It is nice
to commit at this point in case you somehow get into a mess with refactoring - you can always go back to the working version.

There's not a lot to refactor here, but we can introduce another language feature, _module attributes_.

### Module attributes

Module attributes have two main roles in `Elixir`:

1. To annotate somehow the module
2. Work as constants

#### As annotations

```elixir
defmodule HelloWorld do
  @moduledoc """
  Implement functions that returns greetings
  """

  @doc """
  Returns a static greeting

  ## Examples

      iex> HelloWorld.hello()
      "Hello, world"

  """
  def hello do
    "Hello, world"
  end
end
```

In this example, we define the module documentation by using the module attribute syntax. Note that we also used multi-line strings that can be wrapped in three double-quotes.

Another useful reserved attribute is `@doc` that can be used to write documentation for any public function.

`Elixir` promotes the use of `Markdown` to write readable documentation. We can access the documentation of any compiled module directly from the interactive shell

```sh
$ iex

iex> h IO.puts/1
...
```

We'll see more about the interactive shell (`iex`) in other chapter.

#### As "constants"

Another way to use module attributes is to make a value more visible or reusable

```elixir
defmodule Example do
  @prefix "Mx. "

  def greeting(name) do
    "Hello, " <> @prefix <> name
  end
end
```

> Do not add a new line between module attribute name and its value as the compiler will assume you're using the attribute rather than defining it

Module attributes are "private" values so they can't be accessed by other modules unless you define a function to "export" its value

```elixir
defmodule Example do
  @service_uri URI.parse("https://integration.io")

  def service_uri do
    @service_uri
  end
end
```

Note that remote functions may be called when defining a module attribute. In this example we're using the `URI.parse/1` function that validates the given url into a `URI` structure.

> Functions that are defined in the same module of the attribute can't be called to define it as the module (and their functions) have not yet been compiled when the attribute is being defined.

## First refactor

With this new knowledge we can refactor our `HelloWorld` module

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "

  def hello(name) do
    @english_hello_prefix <> name
  end
end
```

After refactoring, re-run your tests to make sure you haven't broken anything.

## Hello, world... again

The next requirement is when our function is called with an empty string it defaults to printing "Hello, World", rather than "Hello, ".

Start by writing a new failing test in our `HelloWorldTest` module

```elixir
describe "hello/1" do
  test "saying hello to people" do
    assert HelloWorld.hello("Zoey") == "Hello, Zoey"
  end

  test "when an empty string is supplied" do
    assert HelloWorld.hello("") == "Hello, world"
  end
end
```

Here we are introducing another tool in our testing arsenal, `describe/2`. Sometimes it is useful to group tests around a "thing" or their context and then have tests describing different scenarios.

A benefit of this approach is you can set up shared code that can be used in the other tests.

Now that we have a well-written failing test, let's fix the code, using an `if`.

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "

  def hello(name) do
    if name == "" do
      @english_hello_prefix <> "world"
    else
      @english_hello_prefix <> name
    end
  end
end
```

Good! If we run our tests we should see it satisfies the new requirement and we haven't accidentally broken the other functionality.

We learned on how to use an `if/2` expression that consists in a condition for a truthy value and a `do-block` with an optional `else` branch. So if the condition pass (results to a truthy value) the code before `else` is executed. If condition evaluates to a falsy value the `else` branch code is executed.

When there isn't an `else` branch and the condition evaluates to falsy, then a `nil` value is returned.

## Pattern matching

`if/2` expressions can be really useful to determine control flow in our code, however `Elixir` also supports the use of [Pattern matching](https://elixir-lang.org/getting-started/pattern-matching.html).

To summarize, pattern matching can be used to check the structure of a given value. Let's take a look on our next refactor to better understanding

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "

  def hello("") do
    @english_hello_prefix <> "world"
  end

  def hello(name) do
    @english_hello_prefix <> name
  end
end
```

Here we are using the multi clause function technique again, but in the first clause the empty string value was "harded-coded". Why this can be better?

The "harded-coded" empty string actually is a pattern that we supply to the function definition, so the compiler will execute this function clause only if an empty string is given.

In the other hand, the second clause of `hello/1` is executed every time a value that isn't an empty string is given, so is the "default" or "fallback" clause in this case.

This is only a try of pattern matching and we will be using it in several forms on future chapters!

### Back to source control

Now we are happy with the code I would amend the previous commit so we only
check in the lovely version of our code with its test.

### Discipline

Let's go over the cycle again

* Write a test
* Make the compiler pass
* Run the test, see that it fails and check the error message is meaningful
* Write enough code to make the test pass
* Refactor

On the face of it this may seem tedious but sticking to the feedback loop is important.

Not only does it ensure that you have _relevant tests_, it helps ensure _you design good software_ by refactoring with the safety of tests.

Seeing the test fail is an important check because it also lets you see what the error message looks like. As a developer it can be very hard to work with a codebase when failing tests do not give a clear idea as to what the problem is.

By ensuring your tests are _fast_ and setting up your tools so that running tests is simple you can get in to a state of flow when writing your code.

By not writing tests you are committing to manually checking your code by running your software which breaks your state of flow and you won't be saving yourself any time, especially in the long run.

## Keep going! More requirements

Goodness me, we have more requirements. We now need to support a second parameter, specifying the language of the greeting. If a language is passed in that we do not recognise, just default to English.

We should be confident that we can use TDD to flesh out this functionality easily!

Write a test for a user passing in Spanish. Add it to the existing suite.

```elixir
test "hello/2" do
  assert HelloWorld.hello("Yan", "Spanish") == "Hola, Yan"
end
```

Remember not to cheat! _Test first_. When you try and run the test, the compiler _should_ complain because you are calling an undefined `hello/2` function.

```sh
  1) test hello/2 (HelloWorldTest)
     hello.exs:38
     ** (UndefinedFunctionError) function HelloWorld.hello/2 is undefined or private. Did you mean one of:

           * hello/0
           * hello/1

     code: assert HelloWorld.hello("Yan", "Spanish") == "Hola, Yan"
     stacktrace:
       HelloWorld.hello("Yan", "Spanish")
       hello.exs:39: (test)

...

Finished in 0.00 seconds (0.00s async, 0.00s sync)
4 tests, 1 failure

Randomized with seed 376422
```

Define a new function `hello/2` that receives a name and a language

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "

  def hello("", language) do
    @english_hello_prefix <> "world"
  end

  def hello(name, language) do
    @english_hello_prefix <> name
  end
end
```

When you try and run the test again it will fail on the grounds that we aren't using the language supplied argument

```sh
  1) test hello/2 (HelloWorldTest)
     hello.exs:46
     Assertion with == failed
     code:  assert HelloWorld.hello("Yan", "Spanish") == "Hola, Yan"
     left:  "Hello, Yan"
     right: "Hola, Yan"
     stacktrace:
       hello.exs:47: (test)

...

Finished in 0.00 seconds (0.00s async, 0.00s sync)
4 tests, 1 failure

Randomized with seed 721482
```

Here you can fix this failure using the `if/2` expression... or try to use pattern matching again!

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "

  def hello("", "Spanish") do
    "Hola, world"
  end

  def hello("", _language) do
    @english_hello_prefix <> "world"
  end

  def hello(name, "Spanish") do
    "Hola, " <> name
  end

  def hello(name, _language) do
    @english_hello_prefix <> name
  end
end
```

OMG, now things are starting to complicate. We defined two more `hello/2` clauses:

- One that receives an empty string and also "Spanish" as language value
- One that receives a name and also "Spanish" as language value

We also modified those old two clause prefixing the "language" argument with an underscore. That's a special syntax that tells to the compiler that this match expression can receive _any_ value and we will ignore it as we don't need them.

The tests should now pass.

Now it is time to _refactor_. You should see some problems in the code, "magic" strings, some of which are repeated. Try and refactor it yourself, with every change make sure you re-run the tests to make sure your refactoring isn't breaking anything.

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "
  @spanish_hello_prefix "Hola, "

  def hello("", "Spanish") do
    @spanish_hello_prefix <> "world"
  end

  def hello("", _language) do
    @english_hello_prefix <> "world"
  end

  def hello(name, "Spanish") do
    @spanish_hello_prefix <> name
  end

  def hello(name, _language) do
    @english_hello_prefix <> name
  end
end
```

### French

* Write a test asserting that if you pass in `"French"` you get `"Bonjour, "`
* See it fail, check the error message is easy to read
* Do the smallest reasonable change in the code

You may have written something that looks roughly like this

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "
  @spanish_hello_prefix "Hola, "
  @french_hello_prefix "Bonjour, "

  def hello("", "Spanish") do
    @spanish_hello_prefix <> "world"
  end

  def hello("", "French") do
    @french_hello_prefix <> "world"
  end

  def hello("", _language) do
    @english_hello_prefix <> "world"
  end

  def hello(name, "Spanish") do
    @spanish_hello_prefix <> name
  end

  def hello(name, "French") do
    @french_hello_prefix <> name
  end

  def hello(name, _language) do
    @english_hello_prefix <> name
  end
end
```

## `case`

Having several many different function clauses in general is not an actual problem, but in some cases you will want to preserve redability while reducing verbosity.

This can be achieved by using a `case/2` expression to avoid adding two new more function clauses every time we want to support a new language.

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "
  @spanish_hello_prefix "Hola, "
  @french_hello_prefix "Bonjour, "

  def hello("", language) do
    case language do
     "Spanish" -> @spanish_hello_prefix <> "world"
     "French" -> @french_hello_prefix <> "world"
     _any -> @english_hello_prefix <> "world"
    end
  end

  def hello(name, language) do
    case language do
     "Spanish" -> @spanish_hello_prefix <> name
     "French" -> @french_hello_prefix <> name
     _any -> @english_hello_prefix <> name
    end
  end
end
```

Write a test to now include a greeting in the language of your choice and you should see how simple it is to extend our _amazing_ function.

### one...last...refactor?

You could argue that maybe our `case/2` logic is being duplicated. The simplest refactor for this would be to extract out this functionality into another function.

```elixir
defmodule HelloWorld do
  @english_hello_prefix "Hello, "
  @spanish_hello_prefix "Hola, "
  @french_hello_prefix "Bonjour, "

  def hello("", language) do
    greeting_prefix(language) <> "world"
  end

  def hello(name, language) do
    greeting_prefix(language) <> name
  end

  defp greeting_prefix("Spanish") do
    @spanish_hello_prefix
  end

  defp greeting_prefix("French") do
    @french_hello_prefix
  end

  defp greeting_prefix(_any) do
    @english_hello_prefix
  end
end
```

Here we defined a new function `greeting_prefix/1` that receives a language with three different clauses that pattern matches with our languages possibilities and also implement a fallback.

Of course you can define this function in term of the `case/2` expression if you prefer.

## Wrapping up

Who knew you could get so much out of `Hello, world`?

By now you should have some understanding of:

### Some of Elixir's syntax around

- Writing and grouping tests
- Defining functions, with arguments and multiple clauses
- Basic usage of Pattern Matching
- `if/2` and `case/2` expressions
- Module attributes

### The TDD process and _why_ the steps are important

* _Write a failing test and see it fail_ so we know we have written a _relevant_ test for our requirements and seen that it produces an _easy to understand description of the failure_
* Writing the smallest amount of code to make it pass so we know we have working software
* _Then_ refactor, backed with the safety of our tests to ensure we have well-crafted code that is easy to work with

In our case we've gone from `hello/0` clause to `hello/1`, to `hello/2` in small, easy to understand steps.

This is of course trivial compared to "real world" software but the principles still stand. TDD is a skill that needs practice to develop, but by breaking problems down into smaller components that you can test, you will have a much easier time writing software.

<!-- CONTENT END -->
