# PokerHands

Returns the winner of two poker hands.

Example input:
  iex> PokerHands.run("2H 3D 5S 9C KD", "2C 3H 4S 8C AH")

Output:
  White wins - high card: ace

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `poker_hands` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:poker_hands, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/poker_hands](https://hexdocs.pm/poker_hands).

