# ParamsMap

A utility module for working with Phoenix and LiveView parameters that are typically string-keyed, but can be accessed and updated using atom keys.

## The Problem

Phoenix and LiveView params arrive as string-keyed maps (e.g. `%{"name" => "Alice", "email" => "alice@example.com"}`). When building forms or handling assigns, atom keys often feel more natural. Manually converting between key types is tedious and error-prone.

## The Solution

ParamsMap provides `Map`-compatible functions that accept atom keys and automatically use the correct key type based on the existing params structure. Write `:name` and it works with both `%{name: "Alice"}` and `%{"name" => "Alice"}`.

## Installation

Add `params_map` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:params_map, "~> 0.0"}
  ]
end
```

## Usage

### Get

```elixir
ParamsMap.get(%{"name" => "Alice"}, :name)           # => "Alice"
ParamsMap.get(%{name: "Alice"}, :name)               # => "Alice"
ParamsMap.get(%{"email" => "a@b.com"}, :name, "N/A") # => "N/A"
```

### Put & Put New

```elixir
ParamsMap.put(%{"a" => 1}, :b, 2)  # => %{"a" => 1, "b" => 2}
ParamsMap.put(%{a: 1}, :b, 2)      # => %{a: 1, b: 2}
ParamsMap.put_new(params, :id, id) # Only sets if key is missing
```

### Update

```elixir
ParamsMap.update(%{"count" => 1}, :count, 0, &(&1 + 1))  # => %{"count" => 2}
ParamsMap.update(%{count: 5}, :count, 0, &(&1 + 1))      # => %{count: 6}
```

### Merge

`merge/2` handles maps with mixed key types by converting one side to match the other:

```elixir
ParamsMap.merge(%{"a" => 1}, %{b: 2})   # => %{"a" => 1, "b" => 2}
ParamsMap.merge(%{a: 1}, %{"b" => 2})   # => %{a: 1, b: 2}
ParamsMap.merge(%{a: 1}, %{b: 2})       # => %{a: 1, b: 2}
```

### Take

Extract specific keys, using atom keys for lookups:

```elixir
ParamsMap.take(%{"name" => "Alice", "email" => "a@b.com"}, [:name])
# => %{"name" => "Alice"}
```

### Clean Embeds

Phoenix form params for nested embeds use map syntax with numeric string keys (`%{"0" => %{...}, "1" => %{...}}`). `clean_embeds/1` converts these to lists for Ecto:

```elixir
ParamsMap.clean_embeds(%{
  "items" => %{
    "0" => %{"name" => "Item 1"},
    "1" => %{"name" => "Item 2"}
  }
})
# => %{
#   "items" => [
#     %{"name" => "Item 1"},
#     %{"name" => "Item 2"}
#   ]
# }
```

## License

MIT
