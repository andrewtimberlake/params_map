defmodule ParamsMap do
  def get(params, key, default \\ nil) when is_atom(key) do
    Map.get(params, to_key(params, key), default)
  end

  def put(params, key, value) when is_atom(key) do
    Map.put(params, to_key(params, key), value)
  end

  def put_new(params, key, value) when is_atom(key) do
    Map.put_new(params, to_key(params, key), value)
  end

  def update(params, key, default, fun) when is_atom(key) do
    Map.update(params, to_key(params, key), default, fun)
  end

  def merge(params1, params2) do
    case {key_type(params1), key_type(params2)} do
      {type, type} ->
        Map.merge(params1, params2)

      {:atom, :binary} ->
        converted_params1 = Map.new(params1, fn {key, value} -> {to_string(key), value} end)
        Map.merge(converted_params1, params2)

      {:binary, :atom} ->
        converted_params2 = Map.new(params2, fn {key, value} -> {to_string(key), value} end)
        Map.merge(params1, converted_params2)
    end
  end

  def take(params, keys) when is_map(params) and is_list(keys) do
    take(keys, params, [])
  end

  defp take([], _params, acc), do: :maps.from_list(acc)

  defp take([key | keys], params, acc) when is_atom(key) do
    key = to_key(params, key)

    acc =
      case params do
        %{^key => value} -> [{key, value} | acc]
        _ -> acc
      end

    take(keys, params, acc)
  end

  def has_key?(params, key) when is_atom(key) do
    Map.has_key?(params, to_key(params, key))
  end

  def drop(params, keys) when is_map(params) and is_list(keys) do
    keys =
      case key_type(params) do
        :atom -> keys
        :binary -> Enum.map(keys, &to_string/1)
      end

    Map.drop(params, keys)
  end

  def clean_embeds(params) do
    Map.new(params, fn
      {key, value} when is_map(value) ->
        case :maps.next(:maps.iterator(value)) do
          {_k, v, _} when is_map(v) ->
            {key, Enum.map(value, fn {_k, v} -> clean_embeds(v) end)}

          _ ->
            {key, value}
        end

      {key, value} ->
        {key, value}
    end)
  end

  defp to_key(params, key) when is_atom(key) do
    case key_type(params) do
      :atom -> key
      :binary -> to_string(key)
    end
  end

  defp key_type(params) do
    case :maps.next(:maps.iterator(params)) do
      :none -> :atom
      {key, _, _} when is_atom(key) -> :atom
      {key, _, _} when is_binary(key) -> :binary
      nil -> raise "params maps should have either atoms or binaries as keys"
    end
  end
end
