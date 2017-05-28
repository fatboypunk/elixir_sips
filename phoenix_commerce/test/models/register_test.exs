defmodule PhoenixCommerce.RegisterTest do
  use PhoenixCommerce.ModelCase
  use ExUnit.Case

  alias PhoenixCommerce.{LineItem, Product, Cart, Register, Order, Repo}
  @upload %Plug.Upload{
          content_type: "image/png",
          filename: "logo-email-b32a431e5255c913b4959a8a99016066.png",
          path: "/Users/marcel/code/elixir_sips/phoenix_commerce/test/files/logo-email-b32a431e5255c913b4959a8a99016066.png"
        }

  setup do
    Repo.delete_all(LineItem)
    Repo.delete_all(Product)
    {:ok, product} =  
      Product.changeset(%Product{}, %{
        name: "some product", 
        description: "some product description",
        price: Decimal.new("2.25"),
        image: @upload 
    }) |> Repo.insert    

    {:ok, cart} = Cart.changeset(%Cart{}, %{ }) |> Repo.insert    

    {:ok, line_item} =  
      LineItem.changeset(%LineItem{}, %{
        product_id: product.id,
        cart_id: cart.id,
        quantity: 1
    }) |> Repo.insert    
    {:ok, cart: cart}
  end

  test "ordering a cart introduces a new order with the cart's line items", %{cart: cart} do
    assert {:ok, order = %Order{}} = Register.order(cart)
    assert 1 = length(order.line_items)
  end
end
