defmodule Ads.Treap.Node do
  alias __MODULE__

  @type t :: %Node{
          left: nil | Node.t(),
          right: nil | Node.t(),
          key: integer(),
          priority: any(),
          data: any()
        }

  @enforce_keys [:left, :right, :key, :priority, :data]
  defstruct @enforce_keys

  def new(key, priority, data) when is_integer(key) do
    %Node{
      left: nil,
      right: nil,
      key: key,
      priority: priority,
      data: data
    }
  end

  def bypass(
        node,
        order \\ :preorder,
        handle_node \\ fn %Node{} = node -> node.data end
      )

  def bypass(nil, _, _), do: []

  def bypass(%Node{} = node, :preorder, handle_node) do
    node
    |> handle_node.()
    |> List.wrap()
    |> Stream.concat(bypass(node.left, :preorder, handle_node))
    |> Enum.concat(bypass(node.right, :preorder, handle_node))
  end

  def bypass(%Node{} = node, :inorder, handle_node) do
    node.left
    |> bypass(:inorder, handle_node)
    |> Stream.concat([handle_node.(node)])
    |> Enum.concat(bypass(node.right, :inorder, handle_node))
  end

  def bypass(%Node{} = node, :postorder, handle_node) do
    node.left
    |> bypass(:postorder, handle_node)
    |> Stream.concat(bypass(node.right, :postorder, handle_node))
    |> Enum.concat([handle_node.(node)])
  end

  def split(nil = _non_existing_node, key) when is_integer(key) do
    {nil, nil}
  end

  def split(%Node{} = node, key) when is_integer(key) do
    if node.key < key do
      {left_splitted_part, right_splitted_part} = split(node.right, key)
      node = %Node{node | right: left_splitted_part}
      {node, right_splitted_part}
    else
      {left_splitted_part, right_splitted_part} = split(node.left, key)
      node = %Node{node | left: right_splitted_part}
      {left_splitted_part, node}
    end
  end

  # We assume that all keys in left are strictly less than in right
  def merge(nil = _non_existent_left, nil = _non_existent_right), do: nil
  def merge(nil = _non_existent_left, %Node{} = right), do: right
  def merge(%Node{} = left, nil = _non_existent_right), do: left

  def merge(%Node{} = left, %Node{} = right) do
    if left.priority < right.priority do
      %Node{right | left: merge(left, right.left)}
    else
      %Node{left | right: merge(left.right, right)}
    end
  end
end
