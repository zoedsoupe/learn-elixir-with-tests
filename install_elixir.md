# Install Elixir

The official installation instructions for Go are available [here](https://elixir-lang.org/install.html).

## Refactoring and your tooling

A big emphasis of this book is around the importance of refactoring.

Your tools can help you do bigger refactoring with confidence.

You should be familiar enough with your editor to perform the following with a simple key combination:

- **Extract/Inline variable**. Being able to take magic values and give them a name lets you simplify your code quickly
- **Extract function**. It is vital to be able to take a section of code and extract functions
- **Rename**. You should be able to confidently rename symbols across files
- **mix format**. `Elixir` has an opinioned formatter called `mix format`. Your editor should be running this on every file save
- **Run tests**. It goes without saying that you should be able to do any of the above and then quickly re-run your tests to ensure your refactoring hasn't broken anything

In addition, to help you work with your code you should be able to:

- **View function signature** - You should never be unsure how to call a function in `Elixir`. Your IDE or text editor should describe a function in terms of its documentation, it's parameters and what it returns. I suggest to take a look on [elixir-ls](https://github.com/elixir-lsp/elixir-ls)
- **View function definition** - If it's still not clear what a function does, you should be able to jump to the source code and try and figure it out yourself.
- **Find usages of a symbol** - Being able to see the context of a function being called can help your decision process when refactoring

Mastering your tools will help you concentrate on the code and reduce context switching.

## Wrapping up

At this point you should have `Elixir` installed, an editor available and some basic tooling in place. `Elixir` has a large and active ecosystem of third party products. We have identified a few useful components here, for a more complete list see https://awesome-elixir.ru.
