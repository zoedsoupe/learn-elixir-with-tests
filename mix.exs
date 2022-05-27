defmodule LEWT.MixProject do
  use Mix.Project

  @name "Learn Elixir with Tests"
  @extras ~w(CONTRIBUTING LICENSE)
  @source_url "https://github.com/zoedsoupe/learn-elixir-with-tests"

  def project do
    [
      app: :lewt,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_options: [warnings_as_errors: true],
      name: @name,
      source_url: @source_url,
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {LEWT.Application, []}
    ]
  end

  defp docs do
    [
      main: @name,
      extras: @extras
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", runtime: false, only: [:docs, :dev]},
      {:livebook_helpers, ">= 0.0.0", only: [:docs, :dev]}
    ]
  end

  defp aliases do
    [docs: ["docs", &copy_images/1, &create_livebook/1]]
  end

  defp copy_images(_) do
    File.cp_r!(Path.expand("./images"), Path.expand("./doc/images"))
  end

  defp create_livebook(_) do
    {parsed, _rest} = OptionParser.parse!(System.argv(), strict: [module: :string, file: :string])

    module = parsed[:module] || "LEWT"
    file = parsed[:file] || "./livebook/lewt"

    Mix.Task.run("create_livebook_from_module", [module, file])
  end
end
