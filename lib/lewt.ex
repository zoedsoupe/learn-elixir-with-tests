defmodule LEWT do
  @external_resource Path.expand("./README.md")

  @moduledoc "./README.md"
             |> Path.expand()
             |> File.read!()
             |> String.split("<!-- README START -->")
             |> Enum.at(1)
             |> String.split("<!-- README END -->")
             |> List.first()
end
