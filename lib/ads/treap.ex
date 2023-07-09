defmodule Ads.Treap do
  alias __MODULE__
  alias Treap.Node

  @type t :: %Treap{
          root: nil | Treap.Node
        }

  @enforce_keys [:root]
  defstruct @enforce_keys

  def new() do
    %Treap{root: nil}
  end

  def bypass(
        %Treap{root: root},
        order \\ :preorder,
        handle_node \\ fn %Node{} = node -> node.data end
      )
      when order in [:preorder, :inorder, :postorder] do
    Node.bypass(root, order, handle_node)
  end

  def put(%Treap{} = treap, key, priority, data) do
    {left, right} = Node.split(treap.root, key)
    left = Node.merge(left, Node.new(key, priority, data))
    root = Node.merge(left, right)
    %Treap{root: root}
  end

  def get(%Treap{} = treap, key, default \\ nil) do
    {_left, right} = Node.split(treap.root, key)
    {middle, _right} = Node.split(right, key + 1)

    case middle do
      nil -> default
      %Node{data: data} -> data
    end
  end
end
