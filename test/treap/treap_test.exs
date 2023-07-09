defmodule Treap.TreapTest do
  alias Ads.Treap

  use ExUnit.Case

  test "treap create" do
    treap = Treap.new()
    assert treap == %Treap{root: nil}
  end

  test "treap put" do
    treap = Treap.new()
    treap = Treap.put(treap, key = 1, priority = 100, data = "Hi")

    assert treap == %Treap{
             root: %Treap.Node{key: key, priority: priority, data: data, left: nil, right: nil}
           }
  end

  test "treap multi put and bypass test" do
    treap = Treap.new()
    treap = Treap.put(treap, _key = 3, _priority = 100, _data = "!")
    treap = Treap.put(treap, _key = 1, _priority = 100, _data = "Hi")
    treap = Treap.put(treap, _key = 2, _priority = 100, _data = "World")

    assert Treap.bypass(treap) == ["Hi", "World", "!"]
    assert Treap.bypass(treap, :preorder) == Treap.bypass(treap)
    assert Treap.bypass(treap, :postorder) == ["!", "World", "Hi"]
  end

  test "treap get" do
    keys_priorities_values =
      Enum.map(1..1000, fn key -> {key, :rand.uniform(), :rand.uniform()} end)

    treap =
      keys_priorities_values
      |> Enum.reduce(Treap.new(), fn {key, priority, value}, treap ->
        Treap.put(treap, key, priority, value)
      end)

    Enum.each(keys_priorities_values, fn {key, _, value} ->
      assert Treap.get(treap, key) == value
    end)
  end
end
