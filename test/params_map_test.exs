defmodule ParamsMapTest do
  use ExUnit.Case, async: true

  test "get/3" do
    assert ParamsMap.get(%{}, :a, 2) == 2
    assert ParamsMap.get(%{a: 1}, :a, 2) == 1
    assert ParamsMap.get(%{b: 1}, :a, 2) == 2
    assert ParamsMap.get(%{"a" => 1}, :a, 2) == 1
    assert ParamsMap.get(%{"b" => 1}, :a, 2) == 2
  end

  test "put/3" do
    assert ParamsMap.put(%{a: 1}, :b, 2) == %{a: 1, b: 2}
    assert ParamsMap.put(%{}, :b, 2) == %{b: 2}
    assert ParamsMap.put(%{"a" => 1}, :b, 2) == %{"a" => 1, "b" => 2}
  end

  test "update/4" do
    assert ParamsMap.update(%{}, :a, 2, fn x -> x + 1 end) == %{a: 2}
    assert ParamsMap.update(%{a: 1}, :a, 2, fn x -> x + 1 end) == %{a: 2}
    assert ParamsMap.update(%{a: 1}, :b, 2, fn x -> x + 1 end) == %{a: 1, b: 2}
    assert ParamsMap.update(%{a: 1, b: 2}, :b, 2, fn x -> x + 1 end) == %{a: 1, b: 3}

    assert ParamsMap.update(%{"a" => 1}, :a, 2, fn x -> x + 1 end) == %{"a" => 2}
    assert ParamsMap.update(%{"a" => 1}, :b, 2, fn x -> x + 1 end) == %{"a" => 1, "b" => 2}

    assert ParamsMap.update(%{"a" => 1, "b" => 2}, :b, 2, fn x -> x + 1 end) == %{
             "a" => 1,
             "b" => 3
           }
  end

  test "merge/2" do
    assert ParamsMap.merge(%{}, %{b: 2}) == %{b: 2}
    assert ParamsMap.merge(%{a: 1}, %{b: 2}) == %{a: 1, b: 2}
    assert ParamsMap.merge(%{"a" => 1}, %{b: 2}) == %{"a" => 1, "b" => 2}
    assert ParamsMap.merge(%{a: 1}, %{"b" => 2}) == %{"a" => 1, "b" => 2}
    assert ParamsMap.merge(%{"a" => 1}, %{"b" => 2}) == %{"a" => 1, "b" => 2}
  end

  test "has_key/2" do
    assert ParamsMap.has_key?(%{a: 1}, :a) == true
    assert ParamsMap.has_key?(%{a: 1}, :b) == false
    assert ParamsMap.has_key?(%{"a" => 1}, :a) == true
    assert ParamsMap.has_key?(%{"a" => 1}, :b) == false
  end

  test "drop/2" do
    assert ParamsMap.drop(%{a: 1, b: 2}, [:a]) == %{b: 2}
    assert ParamsMap.drop(%{a: 1, b: 2}, [:b]) == %{a: 1}
    assert ParamsMap.drop(%{a: 1, b: 2}, [:c]) == %{a: 1, b: 2}
    assert ParamsMap.drop(%{"a" => 1, "b" => 2}, [:a]) == %{"b" => 2}
    assert ParamsMap.drop(%{"a" => 1, "b" => 2}, [:b]) == %{"a" => 1}
    assert ParamsMap.drop(%{"a" => 1, "b" => 2}, [:c]) == %{"a" => 1, "b" => 2}
  end

  test "clean_embeds" do
    assert ParamsMap.clean_embeds(%{
             "amount" => "-20.00",
             "bank_account_id" => "bank_01kehmskmqea0t4ynvgvthmhy7",
             "category" => "Advertising",
             "date" => "2026-01-10",
             "items" => %{
               "0" => %{
                 "_persistent_id" => "0",
                 "category_id" => "cat_01kehmsjsmf77ap9r364t2tm2d",
                 "contact" => "Blue Sky Logistics",
                 "contact_id" => "contact_01kehmsjt9et0by0q4328e6343"
               }
             },
             "notes" => "",
             "original_amount" => "-0.00",
             "original_currency" => ""
           }) == %{
             "amount" => "-20.00",
             "bank_account_id" => "bank_01kehmskmqea0t4ynvgvthmhy7",
             "category" => "Advertising",
             "date" => "2026-01-10",
             "items" => [
               %{
                 "_persistent_id" => "0",
                 "category_id" => "cat_01kehmsjsmf77ap9r364t2tm2d",
                 "contact" => "Blue Sky Logistics",
                 "contact_id" => "contact_01kehmsjt9et0by0q4328e6343"
               }
             ],
             "notes" => "",
             "original_amount" => "-0.00",
             "original_currency" => ""
           }
  end
end
